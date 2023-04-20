import 'package:book_finder/core/di/service_locator_imp.dart';
import 'package:book_finder/modules/details/presenter/pages/book_details_page.dart';
import 'package:book_finder/modules/discover_books/presenter/components/grid_books_component.dart';
import 'package:book_finder/modules/discover_books/presenter/controllers/discover_books_controller.dart';
import 'package:flutter/material.dart';

import '../../../../core/commom/presenter/widgets/loading_widget.dart';
import '../components/search_bar_component.dart';

class DiscoverBooksPage extends StatefulWidget {
  const DiscoverBooksPage({super.key});

  @override
  State<DiscoverBooksPage> createState() => _DiscoverBooksPageState();
}

class _DiscoverBooksPageState extends State<DiscoverBooksPage> with TickerProviderStateMixin {
  final _controller = ServiceLocatorImp.I.get<DiscoverBooksController>();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SearchBarComponent(
          onSearch: (value) {
            _controller.searchBooks(value);
            _tabController.animateTo(0);
          },
        ),
        body: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      bool showfavorites = index == 1;
                      _tabController.animateTo(showfavorites ? 1 : 0);
                      _controller.setTabIsfavorites(showfavorites);
                    },
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'favorites'),
                    ],
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (_controller.isLoading) {
                          return const LoadingWidget();
                        }
                        if (_controller.booksToShow.isEmpty) {
                          return const Center(
                            child: Text(
                              'No books found',
                            ),
                          );
                        }

                        return GridBooksComponent(
                          books: _controller.booksToShow,
                          togglefavorite: _controller.togglefavoriteBook,
                          onTap: (book) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsPage(bookEntity: book),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
