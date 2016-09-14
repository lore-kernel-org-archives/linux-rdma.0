From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [libibverbs, 1/2] Add ibv_query_gid_type to support RoCE v2 UD
 traffic
Date: Tue, 13 Sep 2016 19:10:01 -0600
Message-ID: <20160914011001.GA32157@obsidianresearch.com>
References: <1472575905-25471-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472575905-25471-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 30, 2016 at 07:51:44PM +0300, Yishai Hadas wrote:

> diff --git a/src/libibverbs.map b/src/libibverbs.map
> index 5134bd9..a7d3339 100644
> +++ b/src/libibverbs.map
> @@ -119,4 +119,6 @@ IBVERBS_1.1 {
>  		ibv_cmd_open_qp;
>  		ibv_cmd_rereg_mr;
>  
> +		ibv_query_gid_type;
> +
>  } IBVERBS_1.0;

NAK on incorrect use of the map file.

Also for your other patches.

Use IBVERBS_1.3 as the symbol label.

I wrote this for rdma-plumbing to describe the appropriate approach.

[..]

# Shared Library Versions

The shared libraries use the typical semantic versioning scheme, eg
*libibumad* has a version like `3.1.11`.

The version number is broken up into three fields:
- '3' is called the SONAME and is embedded into the ELF:
   ```sh
   $ readelf -ds build/lib/libibumad.so.3.1.11
    0x000000000000000e (SONAME)             Library soname: [libibumad.so.3]
   ```

   We do not expect this value to ever change for our libraries. It indicates
   the overall ABI, changing it means the library will not dynamically to old
   programs link anymore.

- '1' is called the ABI level and is used within the ELF as the last component
   symbol version tag.  This version must be changed every time a new symbol
   is introduced. It allows the user to see what version of the ABI the
   library provides.

- '11' is the overall release number and is copied from `PACKAGE_VERSION` This
  version increases with every package release, even if the library code did
  not change. It allows the user to see what upstream source was used to build
  the library.

This version is encoded into the filename `build/lib/libibumad.so.3.1.11` and
a symlink from `libibumad.so.3` to `build/lib/libibumad.so.3.1.11` is created.

## Shared Library Symbol Versions

Symbol versions are a linker technique that lets the library author provide
two symbols with different ABIs that have the same API name. The linker
differentiates the two cases internally. This allows the library author to
change the ABI that the API uses. This project typically does not make use of
this feature.

As a secondary feature, the symbol version is also used by package managers
like RPM to manage the ABI level. To make this work properly the ABI level
must be correctly encoded into the symbol version.

## Adding a new symbol

First, increase the ABI level of the library. It is safe to re-use the ABI
level for multiple new functions within a single release, but once a release
is tagged the ABI level becomes *immutable*. The maintainer can provide
guidence on what ABI level to use for each series.

```diff
 rdma_library(ibumad libibumad.map
   # See Documentation/versioning.md
-  3 3.1.${PACKAGE_VERSION}
+  3 3.2.${PACKAGE_VERSION}
```

Next, add your new symbol to the symbol version file:

```diff
+ IBUMAD_3.2 {
+ 	global:
+ 		umad_new_symbol;
+ } IBUMAD_1.0;
```

NOTE: Once a release is made the stanzas in the map file are *immutable* and
cannot be changed. Do not add your new symbol to old stanzas.

The new symbol should appear in the ELF:

```sh
$ readelf -s build/lib/libibumad.so.3.1.11
 35: 00000000000031e0   450 FUNC    GLOBAL DEFAULT   12 umad_new_symbol@@IBUMAD_3.2
```

Finally update the `debian/libibumad3.symbols` file.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
