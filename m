From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma:k.o/for-next 5/34]
 drivers/infiniband/hw/hns/hns_roce_device.h:625:2: error: implicit
 declaration of function '__raw_writeq'
Date: Mon, 14 Aug 2017 17:56:56 +0300
Message-ID: <20170814145656.GJ24282@mtr-leonro.local>
References: <201708131058.lKYk3TId%fengguang.wu@intel.com>
 <5fd6a0f7-cbe4-8bd9-5310-fa2d64ec6829@redhat.com>
 <4871c56c-ce7a-204a-0d54-5ea5aae604fd@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sT0SRK93LqpGW452"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4871c56c-ce7a-204a-0d54-5ea5aae604fd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sT0SRK93LqpGW452
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 14, 2017 at 05:47:59PM +0300, Matan Barak wrote:
> On 14/08/2017 17:40, Doug Ledford wrote:
> > On 8/12/2017 10:09 PM, kbuild test robot wrote:
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git k.o/for-next
> > > head:   d0d62c34fb746eaf68df5b3d6f4877c7d1e6320c
> > > commit: e89bf462b6bece63a60723af88c76dce9dbe6b85 [5/34] IB/hns: Support compile test for hns RoCE driver
> > > config: xtensa-allyesconfig (attached as .config)
> > > compiler: xtensa-linux-gcc (GCC) 4.9.0
> > > reproduce:
> >
> > Hi Matan,
> >
> > I know you have a fix patch for this on list.  I'll grab it this week
> > for sure, so you can ignore this.
> >
> >
>
> Hi Doug,
>
> Thanks :-)
> Just to make things easier, this is the link to that patch:
> https://www.spinics.net/lists/linux-rdma/msg52386.html
>
> In addition, there are a few more patches worth taking to the current RCs
> that fix kernel crashes:
>
> https://www.spinics.net/lists/linux-rdma/msg52485.html
> https://www.spinics.net/lists/linux-rdma/msg52722.html
>
> We have another one coming ("IB/uverbs: Fix NULL pointer dereference during
> device removal"). I guess Leon will post it soon.

I queued it today [1] and planned to submit it EOW.

Doug,
Do you want me to send it earlier?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=c102f66c43cfc568065df6441890621fb6f03002

>
> Thanks,
> Matan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sT0SRK93LqpGW452
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmRujgACgkQ5GN7iDZy
WKcJ8xAArrPFVsUAN4xIz9hleAWOW0IG2Rbp7/prbEda/Mqh4lcD15H7tTV6L8c4
8RDdVNPDBzzR6vbiZCBwaA6gx4hiHtdJVa42uUjrUQy0mGFM5ZYQR8R+azLYtQNC
cp6OpJDqR5NW5b7EJoSOIFYzW/lzsMMlT/SYdwxA1TBmUO0MnAXT8SifirsboRS4
lNOEiZ0zB76d29eBndmZU0b7XrO5LO5n8zy0mKWax1cOsPyDR8iWz0hXG66D4JRs
IRlg9/zYYYqNVfKT23g76SMmfNsAW+naEeltfTsOOitHwvMJ7tOAHVKGbGwlnJQx
MXI3ReSEsedOGDJlxjZb7ag92SNm0dxb70tvRVDWJbR+apXeoWL2MMcfLuu9FUD6
OSC9gz0bcPK2iEVQpMZjRT8jQXg0KetJpiOI07YWRya1M1X+K4xMv/iScVByeLdH
alGIhVVuMU+tZe0ly50iGC3JONRAzlPbU4Uoklvmfa/uNdHjAh6BiLF+z/yl3nKd
0Qmx/bCikD61q8YgtzqePeNlNQUmWgkaQd9fJxpjal4+py59ibGFOtPMyFV14d3W
rdvutR620sfbQFDcFdfNx8+XFkEoRpDKv6LJ7PiJPEUtB0k0Ui5T9PW8VFOo3RgF
3gqzCEHGe2a1PuFEVJ0JoChg+YQsMnIzq/MHD20XfvnrRzgF8dw=
=F7oc
-----END PGP SIGNATURE-----

--sT0SRK93LqpGW452--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
