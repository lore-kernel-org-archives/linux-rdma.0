From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 13/16] Remove Debian and RPM packaging files
Date: Wed, 21 Sep 2016 17:00:41 +0300
Message-ID: <2447bfda-5a48-18db-94b3-d031d5913a8e@dev.mellanox.co.il>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474409425-15769-14-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-14-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/21/2016 1:10 AM, Jason Gunthorpe wrote:
> These no longer apply to the combined build.

Taking this patch without introducing an alternative leaves the system 
without an option to build RPMs as it removes all packaging files.

What is the plan here ?
In addition, did we come to a decision re having RPM per component ?

> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/ibacm.spec.in                                |  90 -----
>  iwpmd/iwpmd.spec.in                                | 127 -------
>  libcxgb3/libcxgb3.spec.in                          |  55 ---
>  libcxgb4/libcxgb4.spec.in                          |  55 ---
>  libhfi1verbs/libhfi1.spec.in                       | 109 ------
>  libi40iw/libi40iw.spec.in                          |  72 ----
>  libibcm/libibcm.spec.in                            |  53 ---
>  libibumad/libibumad.spec.in                        |  74 ----
>  libibverbs/debian/changelog                        | 139 --------
>  libibverbs/debian/compat                           |   1 -
>  libibverbs/debian/control                          |  80 -----
>  libibverbs/debian/copyright                        |  49 ---
>  libibverbs/debian/ibverbs-utils.install            |   2 -
>  libibverbs/debian/libibverbs-dev.install           |   4 -
>  libibverbs/debian/libibverbs-dev.links             |  16 -
>  libibverbs/debian/libibverbs1.install              |   1 -
>  libibverbs/debian/libibverbs1.postinst             |  10 -
>  libibverbs/debian/rules                            |  11 -
>  libibverbs/debian/source/format                    |   1 -
>  libibverbs/debian/watch                            |   3 -
>  libibverbs/libibverbs.spec.in                      | 169 ---------
>  libipathverbs/libipathverbs.spec.in                | 104 ------
>  libmlx4/debian/changelog                           |  73 ----
>  libmlx4/debian/compat                              |   1 -
>  libmlx4/debian/control                             |  47 ---
>  libmlx4/debian/copyright                           |  43 ---
>  libmlx4/debian/libmlx4-1.install                   |   2 -
>  libmlx4/debian/libmlx4-dev.install                 |   1 -
>  .../debian/patches/driver-plugin-directory.patch   |  10 -
>  libmlx4/debian/patches/series                      |   1 -
>  libmlx4/debian/rules                               |  10 -
>  libmlx4/debian/source/format                       |   1 -
>  libmlx4/debian/watch                               |   3 -
>  libmlx4/libmlx4.spec.in                            |  90 -----
>  libmlx5/debian/changelog                           |  18 -
>  libmlx5/debian/compat                              |   1 -
>  libmlx5/debian/control                             |  47 ---
>  libmlx5/debian/copyright                           |  43 ---
>  libmlx5/debian/libmlx5-1.install                   |   2 -
>  libmlx5/debian/libmlx5-dev.install                 |   1 -
>  .../debian/patches/driver-plugin-directory.patch   |  10 -
>  libmlx5/debian/patches/series                      |   1 -
>  libmlx5/debian/rules                               |  10 -
>  libmlx5/debian/source/format                       |   1 -
>  libmlx5/debian/watch                               |   3 -
>  libmlx5/libmlx5.spec.in                            |  60 ----
>  libmthca/debian/changelog                          |  73 ----
>  libmthca/debian/compat                             |   1 -
>  libmthca/debian/control                            |  48 ---
>  libmthca/debian/copyright                          |  44 ---
>  libmthca/debian/libmthca-dev.install               |   1 -
>  libmthca/debian/libmthca1.install                  |   2 -
>  .../debian/patches/driver-plugin-directory.patch   |  10 -
>  libmthca/debian/patches/series                     |   1 -
>  libmthca/debian/rules                              |  10 -
>  libmthca/debian/source/format                      |   1 -
>  libmthca/debian/watch                              |   3 -
>  libmthca/libmthca.spec.in                          |  97 ------
>  libnes/libnes.spec.in                              | 107 ------
>  libocrdma/libocrdma.spec.in                        |  71 ----
>  librdmacm/librdmacm.spec.in                        |  79 -----
>  librxe/librxe.spec.in                              |  55 ---
>  srp_daemon/debian/changelog                        |  11 -
>  srp_daemon/debian/compat                           |   1 -
>  srp_daemon/debian/control                          |  14 -
>  srp_daemon/debian/copyright                        | 376 ---------------------
>  srp_daemon/debian/postinst                         |  26 --
>  srp_daemon/debian/prerm                            |  11 -
>  srp_daemon/debian/rules                            |  14 -
>  srp_daemon/debian/source/format                    |   1 -
>  srp_daemon/srptools.spec.in                        | 141 --------
>  71 files changed, 2902 deletions(-)
>  delete mode 100644 ibacm/ibacm.spec.in
>  delete mode 100644 iwpmd/iwpmd.spec.in
>  delete mode 100644 libcxgb3/libcxgb3.spec.in
>  delete mode 100644 libcxgb4/libcxgb4.spec.in
>  delete mode 100644 libhfi1verbs/libhfi1.spec.in
>  delete mode 100644 libi40iw/libi40iw.spec.in
>  delete mode 100644 libibcm/libibcm.spec.in
>  delete mode 100644 libibumad/libibumad.spec.in
>  delete mode 100644 libibverbs/debian/changelog
>  delete mode 100644 libibverbs/debian/compat
>  delete mode 100644 libibverbs/debian/control
>  delete mode 100644 libibverbs/debian/copyright
>  delete mode 100644 libibverbs/debian/ibverbs-utils.install
>  delete mode 100644 libibverbs/debian/libibverbs-dev.install
>  delete mode 100644 libibverbs/debian/libibverbs-dev.links
>  delete mode 100644 libibverbs/debian/libibverbs1.install
>  delete mode 100644 libibverbs/debian/libibverbs1.postinst
>  delete mode 100755 libibverbs/debian/rules
>  delete mode 100644 libibverbs/debian/source/format
>  delete mode 100644 libibverbs/debian/watch
>  delete mode 100644 libibverbs/libibverbs.spec.in
>  delete mode 100644 libipathverbs/libipathverbs.spec.in
>  delete mode 100644 libmlx4/debian/changelog
>  delete mode 100644 libmlx4/debian/compat
>  delete mode 100644 libmlx4/debian/control
>  delete mode 100644 libmlx4/debian/copyright
>  delete mode 100644 libmlx4/debian/libmlx4-1.install
>  delete mode 100644 libmlx4/debian/libmlx4-dev.install
>  delete mode 100644 libmlx4/debian/patches/driver-plugin-directory.patch
>  delete mode 100644 libmlx4/debian/patches/series
>  delete mode 100755 libmlx4/debian/rules
>  delete mode 100644 libmlx4/debian/source/format
>  delete mode 100644 libmlx4/debian/watch
>  delete mode 100644 libmlx4/libmlx4.spec.in
>  delete mode 100644 libmlx5/debian/changelog
>  delete mode 100644 libmlx5/debian/compat
>  delete mode 100644 libmlx5/debian/control
>  delete mode 100644 libmlx5/debian/copyright
>  delete mode 100644 libmlx5/debian/libmlx5-1.install
>  delete mode 100644 libmlx5/debian/libmlx5-dev.install
>  delete mode 100644 libmlx5/debian/patches/driver-plugin-directory.patch
>  delete mode 100644 libmlx5/debian/patches/series
>  delete mode 100755 libmlx5/debian/rules
>  delete mode 100644 libmlx5/debian/source/format
>  delete mode 100644 libmlx5/debian/watch
>  delete mode 100644 libmlx5/libmlx5.spec.in
>  delete mode 100644 libmthca/debian/changelog
>  delete mode 100644 libmthca/debian/compat
>  delete mode 100644 libmthca/debian/control
>  delete mode 100644 libmthca/debian/copyright
>  delete mode 100644 libmthca/debian/libmthca-dev.install
>  delete mode 100644 libmthca/debian/libmthca1.install
>  delete mode 100644 libmthca/debian/patches/driver-plugin-directory.patch
>  delete mode 100644 libmthca/debian/patches/series
>  delete mode 100755 libmthca/debian/rules
>  delete mode 100644 libmthca/debian/source/format
>  delete mode 100644 libmthca/debian/watch
>  delete mode 100644 libmthca/libmthca.spec.in
>  delete mode 100644 libnes/libnes.spec.in
>  delete mode 100644 libocrdma/libocrdma.spec.in
>  delete mode 100644 librdmacm/librdmacm.spec.in
>  delete mode 100644 librxe/librxe.spec.in
>  delete mode 100644 srp_daemon/debian/changelog
>  delete mode 100644 srp_daemon/debian/compat
>  delete mode 100644 srp_daemon/debian/control
>  delete mode 100644 srp_daemon/debian/copyright
>  delete mode 100644 srp_daemon/debian/postinst
>  delete mode 100644 srp_daemon/debian/prerm
>  delete mode 100755 srp_daemon/debian/rules
>  delete mode 100644 srp_daemon/debian/source/format
>  delete mode 100644 srp_daemon/srptools.spec.in
>
> diff --git a/ibacm/ibacm.spec.in b/ibacm/ibacm.spec.in
> deleted file mode 100644
> index bc337e213516..000000000000
> diff --git a/iwpmd/iwpmd.spec.in b/iwpmd/iwpmd.spec.in
> deleted file mode 100644
> index b00dab0a123e..000000000000
> diff --git a/libcxgb3/libcxgb3.spec.in b/libcxgb3/libcxgb3.spec.in
> deleted file mode 100644
> index 1ae72d793111..000000000000
> diff --git a/libcxgb4/libcxgb4.spec.in b/libcxgb4/libcxgb4.spec.in
> deleted file mode 100644
> index 6b4294468cf0..000000000000
> diff --git a/libhfi1verbs/libhfi1.spec.in b/libhfi1verbs/libhfi1.spec.in
> deleted file mode 100644
> index c6a11ee2a450..000000000000
> diff --git a/libi40iw/libi40iw.spec.in b/libi40iw/libi40iw.spec.in
> deleted file mode 100644
> index 4e794fa1898c..000000000000
> diff --git a/libibcm/libibcm.spec.in b/libibcm/libibcm.spec.in
> deleted file mode 100644
> index ce082726e7dc..000000000000
> diff --git a/libibumad/libibumad.spec.in b/libibumad/libibumad.spec.in
> deleted file mode 100644
> index b01757ff0ef3..000000000000
> diff --git a/libibverbs/debian/changelog b/libibverbs/debian/changelog
> deleted file mode 100644
> index 3ae7711648ce..000000000000
> diff --git a/libibverbs/debian/compat b/libibverbs/debian/compat
> deleted file mode 100644
> index 7f8f011eb73d..000000000000
> diff --git a/libibverbs/debian/control b/libibverbs/debian/control
> deleted file mode 100644
> index a26b75c2aea1..000000000000
> diff --git a/libibverbs/debian/copyright b/libibverbs/debian/copyright
> deleted file mode 100644
> index 5009e7a6039e..000000000000
> diff --git a/libibverbs/debian/ibverbs-utils.install b/libibverbs/debian/ibverbs-utils.install
> deleted file mode 100644
> index 98d15831b4c5..000000000000
> diff --git a/libibverbs/debian/libibverbs-dev.install b/libibverbs/debian/libibverbs-dev.install
> deleted file mode 100644
> index b4c75ce6f1c3..000000000000
> diff --git a/libibverbs/debian/libibverbs-dev.links b/libibverbs/debian/libibverbs-dev.links
> deleted file mode 100644
> index 702902885798..000000000000
> diff --git a/libibverbs/debian/libibverbs1.install b/libibverbs/debian/libibverbs1.install
> deleted file mode 100644
> index 0f3523db5354..000000000000
> diff --git a/libibverbs/debian/libibverbs1.postinst b/libibverbs/debian/libibverbs1.postinst
> deleted file mode 100644
> index 784458a6e0b5..000000000000
> diff --git a/libibverbs/debian/rules b/libibverbs/debian/rules
> deleted file mode 100755
> index 205a8b75e47e..000000000000
> diff --git a/libibverbs/debian/source/format b/libibverbs/debian/source/format
> deleted file mode 100644
> index 163aaf8d82b6..000000000000
> diff --git a/libibverbs/debian/watch b/libibverbs/debian/watch
> deleted file mode 100644
> index eff271adabca..000000000000
> diff --git a/libibverbs/libibverbs.spec.in b/libibverbs/libibverbs.spec.in
> deleted file mode 100644
> index 040948efce17..000000000000
> diff --git a/libipathverbs/libipathverbs.spec.in b/libipathverbs/libipathverbs.spec.in
> deleted file mode 100644
> index d029696d70ef..000000000000
> diff --git a/libmlx4/debian/changelog b/libmlx4/debian/changelog
> deleted file mode 100644
> index ec7ba21e0573..000000000000
> diff --git a/libmlx4/debian/compat b/libmlx4/debian/compat
> deleted file mode 100644
> index 7f8f011eb73d..000000000000
> diff --git a/libmlx4/debian/control b/libmlx4/debian/control
> deleted file mode 100644
> index ab08e00e4eeb..000000000000
> diff --git a/libmlx4/debian/copyright b/libmlx4/debian/copyright
> deleted file mode 100644
> index db07a25fcbf1..000000000000
> diff --git a/libmlx4/debian/libmlx4-1.install b/libmlx4/debian/libmlx4-1.install
> deleted file mode 100644
> index 8cab406b098d..000000000000
> diff --git a/libmlx4/debian/libmlx4-dev.install b/libmlx4/debian/libmlx4-dev.install
> deleted file mode 100644
> index 8f70e5214388..000000000000
> diff --git a/libmlx4/debian/patches/driver-plugin-directory.patch b/libmlx4/debian/patches/driver-plugin-directory.patch
> deleted file mode 100644
> index fd73a739f424..000000000000
> diff --git a/libmlx4/debian/patches/series b/libmlx4/debian/patches/series
> deleted file mode 100644
> index 213f49e4c278..000000000000
> diff --git a/libmlx4/debian/rules b/libmlx4/debian/rules
> deleted file mode 100755
> index 9d15bec7c2a8..000000000000
> diff --git a/libmlx4/debian/source/format b/libmlx4/debian/source/format
> deleted file mode 100644
> index 163aaf8d82b6..000000000000
> diff --git a/libmlx4/debian/watch b/libmlx4/debian/watch
> deleted file mode 100644
> index 06bae51d7eb3..000000000000
> diff --git a/libmlx4/libmlx4.spec.in b/libmlx4/libmlx4.spec.in
> deleted file mode 100644
> index 3c93122b5a02..000000000000
> diff --git a/libmlx5/debian/changelog b/libmlx5/debian/changelog
> deleted file mode 100644
> index f43b43f41dfd..000000000000
> diff --git a/libmlx5/debian/compat b/libmlx5/debian/compat
> deleted file mode 100644
> index 7f8f011eb73d..000000000000
> diff --git a/libmlx5/debian/control b/libmlx5/debian/control
> deleted file mode 100644
> index 0aceae4a25ae..000000000000
> diff --git a/libmlx5/debian/copyright b/libmlx5/debian/copyright
> deleted file mode 100644
> index db07a25fcbf1..000000000000
> diff --git a/libmlx5/debian/libmlx5-1.install b/libmlx5/debian/libmlx5-1.install
> deleted file mode 100644
> index 1af89543be5a..000000000000
> diff --git a/libmlx5/debian/libmlx5-dev.install b/libmlx5/debian/libmlx5-dev.install
> deleted file mode 100644
> index 7de9fbe4978b..000000000000
> diff --git a/libmlx5/debian/patches/driver-plugin-directory.patch b/libmlx5/debian/patches/driver-plugin-directory.patch
> deleted file mode 100644
> index 91eb0482b3bb..000000000000
> diff --git a/libmlx5/debian/patches/series b/libmlx5/debian/patches/series
> deleted file mode 100644
> index 213f49e4c278..000000000000
> diff --git a/libmlx5/debian/rules b/libmlx5/debian/rules
> deleted file mode 100755
> index c8a46746512a..000000000000
> diff --git a/libmlx5/debian/source/format b/libmlx5/debian/source/format
> deleted file mode 100644
> index 163aaf8d82b6..000000000000
> diff --git a/libmlx5/debian/watch b/libmlx5/debian/watch
> deleted file mode 100644
> index cf13e694b2f8..000000000000
> diff --git a/libmlx5/libmlx5.spec.in b/libmlx5/libmlx5.spec.in
> deleted file mode 100644
> index 8c73c40fea39..000000000000
> diff --git a/libmthca/debian/changelog b/libmthca/debian/changelog
> deleted file mode 100644
> index d106ed76b49a..000000000000
> diff --git a/libmthca/debian/compat b/libmthca/debian/compat
> deleted file mode 100644
> index 7f8f011eb73d..000000000000
> diff --git a/libmthca/debian/control b/libmthca/debian/control
> deleted file mode 100644
> index 5ad14106b85c..000000000000
> diff --git a/libmthca/debian/copyright b/libmthca/debian/copyright
> deleted file mode 100644
> index 04abee0b74f7..000000000000
> diff --git a/libmthca/debian/libmthca-dev.install b/libmthca/debian/libmthca-dev.install
> deleted file mode 100644
> index e8122b99f572..000000000000
> diff --git a/libmthca/debian/libmthca1.install b/libmthca/debian/libmthca1.install
> deleted file mode 100644
> index 7d1d899e896f..000000000000
> diff --git a/libmthca/debian/patches/driver-plugin-directory.patch b/libmthca/debian/patches/driver-plugin-directory.patch
> deleted file mode 100644
> index 2ed7a66a24c0..000000000000
> diff --git a/libmthca/debian/patches/series b/libmthca/debian/patches/series
> deleted file mode 100644
> index 213f49e4c278..000000000000
> diff --git a/libmthca/debian/rules b/libmthca/debian/rules
> deleted file mode 100755
> index 902923802e67..000000000000
> diff --git a/libmthca/debian/source/format b/libmthca/debian/source/format
> deleted file mode 100644
> index 163aaf8d82b6..000000000000
> diff --git a/libmthca/debian/watch b/libmthca/debian/watch
> deleted file mode 100644
> index 8010f867b5d5..000000000000
> diff --git a/libmthca/libmthca.spec.in b/libmthca/libmthca.spec.in
> deleted file mode 100644
> index f23a159a5b97..000000000000
> diff --git a/libnes/libnes.spec.in b/libnes/libnes.spec.in
> deleted file mode 100644
> index 251365aedd1d..000000000000
> diff --git a/libocrdma/libocrdma.spec.in b/libocrdma/libocrdma.spec.in
> deleted file mode 100644
> index 5f7d9f13c527..000000000000
> diff --git a/librdmacm/librdmacm.spec.in b/librdmacm/librdmacm.spec.in
> deleted file mode 100644
> index e89aa16095bf..000000000000
> diff --git a/librxe/librxe.spec.in b/librxe/librxe.spec.in
> deleted file mode 100644
> index 16dbaa615946..000000000000
> diff --git a/srp_daemon/debian/changelog b/srp_daemon/debian/changelog
> deleted file mode 100644
> index edf8422ace3f..000000000000
> diff --git a/srp_daemon/debian/compat b/srp_daemon/debian/compat
> deleted file mode 100644
> index 45a4fb75db86..000000000000
> diff --git a/srp_daemon/debian/control b/srp_daemon/debian/control
> deleted file mode 100644
> index c2b24a5d66ff..000000000000
> diff --git a/srp_daemon/debian/copyright b/srp_daemon/debian/copyright
> deleted file mode 100644
> index 34994d31ea0b..000000000000
> diff --git a/srp_daemon/debian/postinst b/srp_daemon/debian/postinst
> deleted file mode 100644
> index 12e59820e44a..000000000000
> diff --git a/srp_daemon/debian/prerm b/srp_daemon/debian/prerm
> deleted file mode 100644
> index eb39bcb74d3c..000000000000
> diff --git a/srp_daemon/debian/rules b/srp_daemon/debian/rules
> deleted file mode 100755
> index 648c6aa5c167..000000000000
> diff --git a/srp_daemon/debian/source/format b/srp_daemon/debian/source/format
> deleted file mode 100644
> index 163aaf8d82b6..000000000000
> diff --git a/srp_daemon/srptools.spec.in b/srp_daemon/srptools.spec.in
> deleted file mode 100644
> index 750cab3cc485..000000000000
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
