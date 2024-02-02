import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ManifestController } from './manifest/manifest.controller';

@Module({
  imports: [],
  controllers: [AppController, ManifestController],
  providers: [AppService],
})
export class AppModule {}
