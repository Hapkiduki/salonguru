import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/domain/repositories/products_repository.dart';
import 'package:salonguru/domain/usecases/base_use_case.dart';

class GetProductsUseCase implements BaseUseCase<List<Product>, NoParams> {
  const GetProductsUseCase({
    required ProductsRepository productsRepository,
  }) : _productsRepository = productsRepository;

  final ProductsRepository _productsRepository;

  @override
  Future<Result<List<Product>>> call(NoParams params) => _productsRepository.getProducts();
}
