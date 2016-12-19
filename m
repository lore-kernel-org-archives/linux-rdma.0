From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V6 00/14] SG-based RDMA ABI Proposal
Date: Mon, 19 Dec 2016 08:28:41 +0200
Message-ID: <20161219062841.GP1074@mtr-leonro.local>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
 <20161219004854.GA12723@phlsvsds.ph.intel.com>
 <20161219055037.GO1074@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E3C611539@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o41d8xLWOaLD8vYh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E3C611539-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--o41d8xLWOaLD8vYh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 19, 2016 at 06:07:55AM +0000, Weiny, Ira wrote:
> > > These don't apply to any Doug branches I have tried.  (I don't see a
> > > for-4.9-fixed branch at:)
> > >
> > > https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/refs/he
> > > ads
> > >
> > > Doug, have you accepted Leon's IOCTL series?
> >
> > Yes, Doug accepted it.
> >
>
> Do you know what branch they are on?

It puzzled me too, but since the code is available in Matan's repo [1],
I didn't bother myself.

[1] https://github.com/matanb10/linux abi_rfc_pre_v6

>
> Ira
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--o41d8xLWOaLD8vYh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhXfhgACgkQ5GN7iDZy
WKfMCg/8DuOCOwA7KBWocD1kPZtspgUjFHQnUur0N9aVF6RXfTUUAeNrpzeiMQ9P
o6xGPgimsLlxEQgHaMn14dZBhIAP4nW9Gsx+CgQZ4DD0yvnFlx/pVzKWGikM0PLT
ODGBpqXZIp0I/0Jr5GOQd8RxjUL8WJzHdAKNsygjk3nTWq6mYX3bIlbvuTxvkcLK
C5A1/M5KpuelLZHDJumuiKmh+vr08FgbglvIdsYGinM2mNisYZTJ+7sMsja7nI8g
rx7lwQsANo15GTrGifjePC1owIVmVKi+GYyTS3v6W7b2fQZ0E5pAgJ516OM9qV0e
nsHstCN6BrNSBaLIT08PVI1DgOs4R/wNNcHvkimCVXqXRQewBvec9Q0oB++bk96K
ZueVH8MQxAv+m671peDovq+FtN+YfMlzB40G7fEwmndxGyQal9peHg7iDF43KYF7
tUGvcUxr/gVWuZiFR+6YBHjMLTo7kkGL4/JUD1iPrEoehifkQplhgeVsP1spumTN
3VXnNpCb/u+yTkf2tINTYmnEsTBZCjvGYQBq08+Idk9nc/QpiosRg1JKBvvmHkMK
w55MB/oG+R45fbb0UO1cbDGoVCMsT5sjq8FaHOPp4IXON4GzRTHD8YnYb/F1wZLw
DxtAtTQkJ+vXIvIN8Sqor+2Jhzfs4uEA0g7ORH2SLPNwo3Zkiww=
=OXtV
-----END PGP SIGNATURE-----

--o41d8xLWOaLD8vYh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
