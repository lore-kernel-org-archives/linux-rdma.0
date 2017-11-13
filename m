From: Debian FTP Masters <ftpmaster-Lx6IQGP78c/Z1gQgfCZkLYSLwOllVvif@public.gmane.org>
Subject: rdma-core_15-1_amd64.changes ACCEPTED into unstable, unstable
Date: Mon, 13 Nov 2017 23:00:17 +0000
Message-ID: <E1eENiD-000EaM-BG@fasolo.debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Mon, 18 Sep 2017 11:00:39 +0200
Source: rdma-core
Binary: rdma-core ibacm ibverbs-providers ibverbs-utils libibverbs-dev libibverbs1 libibcm-dev libibcm1 libibumad-dev libibumad3 librdmacm-dev librdmacm1 rdmacm-utils srptools
Architecture: source amd64
Version: 15-1
Distribution: unstable
Urgency: medium
Maintainer: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Changed-By: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Description:
 ibacm      - InfiniBand Communication Manager Assistant (ACM)
 ibverbs-providers - User space provider drivers for libibverbs
 ibverbs-utils - Examples for the libibverbs library
 libibcm-dev - Development files for the libibcm library
 libibcm1   - InfiniBand Communication Manager (CM) library
 libibumad-dev - Development files for libibumad
 libibumad3 - InfiniBand Userspace Management Datagram (uMAD) library
 libibverbs-dev - Development files for the libibverbs library
 libibverbs1 - Library for direct userspace use of RDMA (InfiniBand/iWARP)
 librdmacm-dev - Development files for the librdmacm library
 librdmacm1 - Library for managing RDMA connections
 rdma-core  - RDMA core userspace infrastructure and documentation
 rdmacm-utils - Examples for the librdmacm library
 srptools   - Tools for Infiniband attached storage (SRP)
Closes: 848971
Changes:
 rdma-core (15-1) unstable; urgency=medium
 .
   * New upstream version. ibverbs-providers combines the source packages
     libcxgb3, libipathverbs, libmlx4, libmlx5, libmthca, and libnes.
     rdma-core also combines the source packages ibacm, libibcm, libibumad,
     libibverbs, librdmacm, and srptools (Closes: #848971)
Checksums-Sha1:
 5c9af013b2570e96449e9e55c1272f6a54b9a96b 2830 rdma-core_15-1.dsc
 26da48113931fdd210441c07ae55176cb4d71808 883435 rdma-core_15.orig.tar.gz
 1bc89614c0300212d320c0b4fa059c1c5e209d67 16852 rdma-core_15-1.debian.tar.xz
 23e646c8fd39ca3ed0ab67cc0975f43bcecabeae 161268 ibacm-dbgsym_15-1_amd64.deb
 1a412e75023422114e1cce8e263d7522f15f9004 75828 ibacm_15-1_amd64.deb
 ecf760e1cb6737c6f00a9333a4448f9df5def3b3 869406 ibverbs-providers-dbgsym_15-1_amd64.deb
 93cf8569a104f9b86018e5f11f92c109ef64f20d 148988 ibverbs-providers_15-1_amd64.deb
 ceeeec0cca5ebee1682492d6f22a1c8f0d7f74c9 205396 ibverbs-utils-dbgsym_15-1_amd64.deb
 b9d71016a296b51a0ff447d6be0a420808b2eafd 50364 ibverbs-utils_15-1_amd64.deb
 995ec67c73d7a29e6fa64978c35992d5107a0cf7 14224 libibcm-dev_15-1_amd64.deb
 a170080da000ac433c16ee4c3fe45ba669c89756 27832 libibcm1-dbgsym_15-1_amd64.deb
 0490c072c9530e39e0b0f7dcedf8857996a8861b 16312 libibcm1_15-1_amd64.deb
 d0bfa5508e7b4c6f716644f8f653c9bdb8201ef0 36454 libibumad-dev_15-1_amd64.deb
 174f92ebe8096cb95612c08f8d5c17ea13b9bf09 29584 libibumad3-dbgsym_15-1_amd64.deb
 2b43b8d8f6985c4f00bd215de2777ceb4d858b9d 23754 libibumad3_15-1_amd64.deb
 674db35b4b54b4d1887bbfe574fea089a6745f0f 97044 libibverbs-dev_15-1_amd64.deb
 0ef04b4097d545c54e66d17f1ac60ad6988747ae 124946 libibverbs1-dbgsym_15-1_amd64.deb
 ccf81464d626e79a6ee4b22c2bad362a2e12563c 42928 libibverbs1_15-1_amd64.deb
 61056fc49cbf9d63eb1778c186622888d0c8d870 68606 librdmacm-dev_15-1_amd64.deb
 c86933ba9333e6dd5122beeb77e56a7fc88b135c 153228 librdmacm1-dbgsym_15-1_amd64.deb
 41a2c3141a9852454dee2c54a0ba1676d9f08cda 56398 librdmacm1_15-1_amd64.deb
 8f2dd9b831c835f714782912fef439a9b3d9e7f8 51470 rdma-core-dbgsym_15-1_amd64.deb
 f0ac41a669e27d0fbcf973083f1c3913c1cc8cd1 11780 rdma-core_15-1_amd64.buildinfo
 d5e22c3daf716246f9e68938a8fb0475e40de187 50652 rdma-core_15-1_amd64.deb
 c186ff3efa91fb98ccb64cca855869fb85cde048 234356 rdmacm-utils-dbgsym_15-1_amd64.deb
 9bac447f0c2a6803cae86fc1e7f18bc3f6816ef2 67982 rdmacm-utils_15-1_amd64.deb
 8fcf7a8d3da4f617faa306ef3dba2e291f5c18de 69078 srptools-dbgsym_15-1_amd64.deb
 f4c5faa7cc2a5f4c869d0b5baef3b88ab8e01823 39258 srptools_15-1_amd64.deb
Checksums-Sha256:
 753ded10829accfb916327d1fd16f275d82a3981ffa20202787bb46309d5ce3b 2830 rdma-core_15-1.dsc
 8015dc6749c7b89916b5297e07611cbbf8fcc26b9a37e1aba6188454f684012b 883435 rdma-core_15.orig.tar.gz
 73a8c8e43f6592c1ab957013096ef551197f9a587e228c007d748c025fedeb74 16852 rdma-core_15-1.debian.tar.xz
 44d16ec56d208e638689dd502f07611d7eb33bb02998d209551256ebbd4c2a89 161268 ibacm-dbgsym_15-1_amd64.deb
 7af9baf46d5b165ce8ffc6d0152e3f5d8ac9a6398d9c1bf3b507c78ae7fa5347 75828 ibacm_15-1_amd64.deb
 17be4c47c01a44c9d780a046f792421c65d63b209532bf1a4989c5aaa5d144e2 869406 ibverbs-providers-dbgsym_15-1_amd64.deb
 a392edf99c07ac1d8890bf6775df17a2632b0bf1281364bb3f9cee43d82dfca0 148988 ibverbs-providers_15-1_amd64.deb
 015ab4528b6a261245ad5ec3d599d23dcd50b3e2fc25c804e050bcc9d3bbc362 205396 ibverbs-utils-dbgsym_15-1_amd64.deb
 08234d261f865eac5005f316ad054d227bc74cefef3d5301a54faf43df6a27e7 50364 ibverbs-utils_15-1_amd64.deb
 6f06bd966eb6ccfc3d83b287deb72c2dd940c48c0966b146a9fb7aa38c4315ad 14224 libibcm-dev_15-1_amd64.deb
 3f0bca152f75582939ab3c0e4deef8ba69be1b74f6b790c6ebdacfadcc19f58a 27832 libibcm1-dbgsym_15-1_amd64.deb
 8d52dfb8e62d3f15cdc5a427fb63c83b0f87c15ade33c527d05cf5b3365b2f15 16312 libibcm1_15-1_amd64.deb
 5065ca64d31b583e691d2d2b16246af1a28f7a24508ea01ddd40f1ca5ab09c3f 36454 libibumad-dev_15-1_amd64.deb
 f2d2404b1a2968da6cfd42b6385a828d47257b4606bca3451f58015127b33cff 29584 libibumad3-dbgsym_15-1_amd64.deb
 c9bbb778aa25cfac55fe93c34b6a5a7fe91b5111ea01098bb7f6d8b4babbbbeb 23754 libibumad3_15-1_amd64.deb
 1848cb9af511bd6855f7842fbfcfad06e4f9a817afcd2ebbd4db0f6c4e07773a 97044 libibverbs-dev_15-1_amd64.deb
 911693aeca05d97175b41be71c755c4b9fd4bd2cb322d8f70ace723738765d54 124946 libibverbs1-dbgsym_15-1_amd64.deb
 692225511eb814c58e14ed413f9ef9eaec4d3703f91181d7993e8459dd5eb3df 42928 libibverbs1_15-1_amd64.deb
 daa570092a0decc22c442e2e40d96062007414da843150708dfa8821661f59d8 68606 librdmacm-dev_15-1_amd64.deb
 6e886fe918201c3282b5a927c791c50c490636fdbeb8a2f03e589a03eb6cc7f9 153228 librdmacm1-dbgsym_15-1_amd64.deb
 324decf21548bdc53c6ba9519b5aceae805c95f87aecb17b7f1662268a98cfd5 56398 librdmacm1_15-1_amd64.deb
 3fc447b87014125aa4c61ef26a04e9841db769eba44193602b07da4ab74c4278 51470 rdma-core-dbgsym_15-1_amd64.deb
 76e6b68bae91426ca6c04bc53b84409727cbae239a8d20c76ff6dd335df0acd3 11780 rdma-core_15-1_amd64.buildinfo
 7005307c245fbc949d1982770f5a7ce119023107d0d108f7af54108f51f5ef3c 50652 rdma-core_15-1_amd64.deb
 c791d3ded7baae78b426b5b56c281db622e4cb3c4065743dd742096e254530f8 234356 rdmacm-utils-dbgsym_15-1_amd64.deb
 9e9bfb0ad35cbfcdfa341e77916aa9a6a23017a1604f9eb4d51bd462583688f3 67982 rdmacm-utils_15-1_amd64.deb
 6109dc9ff54c5ac2e43d6fcbb85f669354b257a94e32a3e8b503d260182baddb 69078 srptools-dbgsym_15-1_amd64.deb
 2e847c31346d0e8b90c017a8131daebf0ba804413c969033541666cbf3d4a289 39258 srptools_15-1_amd64.deb
Files:
 d8e620db421cc834091310cf68862727 2830 net optional rdma-core_15-1.dsc
 a3287994ff0f389582c9959f5bc82615 883435 net optional rdma-core_15.orig.tar.gz
 11e3dc2bda38017cb50cae161151a374 16852 net optional rdma-core_15-1.debian.tar.xz
 0178601bab11810c581f798996d5d678 161268 debug optional ibacm-dbgsym_15-1_amd64.deb
 8a5283a63651c9033b0feff807ef5802 75828 net optional ibacm_15-1_amd64.deb
 713e24740016786346ef786de335d3ab 869406 debug optional ibverbs-providers-dbgsym_15-1_amd64.deb
 e243a5181979819ae3427ca69d07611b 148988 net optional ibverbs-providers_15-1_amd64.deb
 e7fc99fc2adca6ee15559a7dddf1343e 205396 debug optional ibverbs-utils-dbgsym_15-1_amd64.deb
 93c4cc2b2bf67e36a1fcab006b222a1e 50364 net optional ibverbs-utils_15-1_amd64.deb
 055825e5aef50db83a61ad1d3854b4f2 14224 libdevel optional libibcm-dev_15-1_amd64.deb
 2e5a6fed027fae75eed604b1bdca58de 27832 debug optional libibcm1-dbgsym_15-1_amd64.deb
 7942ba3e653bfa7499aa662a80359a46 16312 libs optional libibcm1_15-1_amd64.deb
 3aa2ac354482ee3d412b4b099343931b 36454 libdevel optional libibumad-dev_15-1_amd64.deb
 04222cfded73c071f9a8f595ed3e2132 29584 debug optional libibumad3-dbgsym_15-1_amd64.deb
 0118bd61a9abca28d920677a58831a5f 23754 libs optional libibumad3_15-1_amd64.deb
 d2cf9485a05a0cc2ed3f1d1f42894070 97044 libdevel optional libibverbs-dev_15-1_amd64.deb
 5875b9cb23ca535cc5b68ed9f684485c 124946 debug optional libibverbs1-dbgsym_15-1_amd64.deb
 a9e04e9d7fa795c994544e17e557f4c4 42928 libs optional libibverbs1_15-1_amd64.deb
 d8e37f492d2ef35cceb5347e9c9d4c00 68606 libdevel optional librdmacm-dev_15-1_amd64.deb
 fd45c6b16dfe4df130ece2a0dd926f47 153228 debug optional librdmacm1-dbgsym_15-1_amd64.deb
 729fde37c0b73bf8ca8c2fcf16300ae4 56398 libs optional librdmacm1_15-1_amd64.deb
 4dde262bfd629fc80952444419668e79 51470 debug optional rdma-core-dbgsym_15-1_amd64.deb
 dd4b42586841a837124466b30e8f377f 11780 net optional rdma-core_15-1_amd64.buildinfo
 10f3293a296e98918448d39c94f75ceb 50652 net optional rdma-core_15-1_amd64.deb
 563c7dc541e6155bf513708c143a29c5 234356 debug optional rdmacm-utils-dbgsym_15-1_amd64.deb
 567cf6d7bfead58f2f879edac3bca6a7 67982 net optional rdmacm-utils_15-1_amd64.deb
 e7f631e0d6dc775558cace66f8847b05 69078 debug optional srptools-dbgsym_15-1_amd64.deb
 c59d58158b999c074c46af61e4c25725 39258 net optional srptools_15-1_amd64.deb

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZv44QAAoJEN2M1aXejH564gUQAIfky3snkNEXLM4sjZCjC27T
bfat0lhDDjUgvncoHNyDhb+j6vlRYzzu6Hcxg/R7lO+CweuBLFeGzj7rsq8Bi+L8
0QUigyGPXK8lCeUE06Wy/iRREEwb99eVKr+pbUEZjecI53f2TiN42kpKYKFT2zSK
HCYcaQX0gZ44x9i40YDqyInQEH1xUzsKdW+CFbtGg4zVx6KibTtSn6rWD7B/WweF
3ixUPK6XcpSr3gFItpHvWYexQi80gkP3MkjcnQUCGu0ZgOKFCBe2gpVjJMM3Wskn
Mn+kX48mSLaugnY2ChP9K95LjE6R3KD5liPRum8IrSMv6DyoEiEmHDQqHmhs8kew
/SyqqB8lrUeLrv4EnbxqoigtweLUCGckla7LxtlFB8YUCWwlvsm+Eq8fASfpEUm9
a/KUqhWS7uZVCe4/bDcVV+6otLa9gbHp3Kbf2ysKP83HntXq6uhwYTvMDSom7Fjv
118h6dpZvhI0JE29OMsoXrWR/zkMXoZZKsQ2IOe+wStVbG2TEZ2DZzpI4HlmjCTH
+ltxHvNnQMJ/Xuw5sfU9ra6KTZzauRs6meFEpgkYJNpWOgj/j2hkroUdu+/qtg4Y
fViDmmmcOEGaIDmruzfGduAqlW/8hgWlsqwatGu371MQ9f+sSMY9dwg6LpfCJnzQ
o0wF/5FRijt95YSQbjaD
=R23x
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
