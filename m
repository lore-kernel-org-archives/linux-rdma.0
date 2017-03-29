From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Wed, 29 Mar 2017 14:21:55 +0300
Message-ID: <20170329112155.GK20443@mtr-leonro.local>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170327195500.GH20443@mtr-leonro.local>
 <20170327201714.GB29831@srabinov-linux.uk.oracle.com>
 <20170328091940.GA14058@srabinov-linux.uk.oracle.com>
 <20170328170506.GI20443@mtr-leonro.local>
 <20170329102019.GA19012@srabinov-linux.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3CAnR4CLEnEWqRMR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170329102019.GA19012-t9juWtktDCT52KUv/Ok+f8QLKKaP9WJ9VpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--3CAnR4CLEnEWqRMR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 29, 2017 at 01:20:20PM +0300, Shamir Rabinovitch wrote:
> On Tue, Mar 28, 2017 at 08:05:06PM +0300, Leon Romanovsky wrote:
> >
> > Thank you for checking it.
> >
> > There is one more thing which I noticed, you should check the return
> > values of debugfs_remove and destroy debugfs in case of failures.
> >
>
> Hi Leon,
>
> 'debugfs_remove' prototype is "static inline void
> debugfs_remove(struct dentry *dentry)".
> If you typed the wrong function please let me know.

Sorry, it was my fault, I mistyped and intended to write debugfs_rename
which you used in previous version of your patch.

 linux-rdma git:(master) git grep debugfs_rename
 ....
fs/debugfs/inode.c: * debugfs_rename - rename a file/directory in the debugfs filesystem
fs/debugfs/inode.c:struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
fs/debugfs/inode.c:EXPORT_SYMBOL_GPL(debugfs_rename);
 ....

>
> BR, Shamir
>

--3CAnR4CLEnEWqRMR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljbmNIACgkQ5GN7iDZy
WKdUjA/8CwXZFPdSjEoJbCpzZ9hi3vnKA0UntGa3gBmsEmh5oS87wo/z+UEC3KcC
5UFJ5lFInVyedwNebQbRWK21vZIpI4NzYDv4XZLhUaDdIAPL3Kl2rS4BLoW5hYNN
XZNT326omZnVml/3Jk8myd/R8ceDAbPs1hUr35WLwjSG7q5CLLMTpuqO4d+evjzA
fOOSfPu6u8McvtLCaBx0dHmrGH8dQtASeGXKQHELvUkVFkIA+gJSHey0m8wJhYof
6OaZ+Rno/okah2f7uxEfPDUqIkdRcsVgzrmkjc8/BAdb7T2RSTjPLKscKo85vX5B
28GR334+3iWngwFk/6ZCs0lD0Fg9xYZ8pi+HhJrcPDpIOlOhhMixmj7bvJ8Qgi9Y
bcJj2sERxn/udPQP0tv8Y95z2u3IucNe4uHysthFHTEQ/B528+6ns4r1Ipgs+h3S
ILIW1pg6UaPvO7HJkeYjX0K50jHEPw6xUILNQS63sRRDraBjjFhPqs5fAgqBH0lb
ZEIyDf0zFBmlj27fyltMMTew0rAhlb2ldagETfXfwIomfmzXtmQ05cfl84xI9bbi
un8PI6yoWxbsE0AdJBDpBh2eyMwrFcuUFPVtgtfCYA98fUv2KSfy3I1fF5wjHCRO
VWF8TaQaX35rMaUK8OULfo/eIyCRMgXnTTofkUo8E0s5MjRdEo8=
=1TDY
-----END PGP SIGNATURE-----

--3CAnR4CLEnEWqRMR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
