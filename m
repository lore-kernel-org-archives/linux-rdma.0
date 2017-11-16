From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: vmw_pvrdma: Add SRQ support - broke rdma-core
Date: Thu, 16 Nov 2017 07:21:19 +0200
Message-ID: <20171116052119.GF18825@mtr-leonro.local>
References: <20171114085143.GS18825@mtr-leonro.local>
 <20171114182720.GC18825@mtr-leonro.local>
 <20171114190029.GI18825@mtr-leonro.local>
 <20171114192510.GA6083@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171114192858.GM4263@ziepe.ca>
 <20171115024924.GA23574@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171115031526.GJ25894@ziepe.ca>
 <20171115221052.GA16946@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pVyBEWmAlQI22d4i"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171115221052.GA16946-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pVyBEWmAlQI22d4i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 15, 2017 at 02:10:54PM -0800, Bryan Tan wrote:
> On Tue, Nov 14, 2017 at 08:15:26PM -0700, Jason Gunthorpe wrote:
> > On Tue, Nov 14, 2017 at 06:49:25PM -0800, Bryan Tan wrote:
> >
> > > Thanks for your suggestion, Jason. I've opened up a new pull request
> > > that includes the original commit for SRQ support that has been
> > > reverted, along with the one line change you suggested. Let me know if
> > > you prefer something different. I've run the travis build on kernels
> > > both with and without the new ABI header as well.
> >
> > You should swap the order of the two patches and move the change of
> > buildlib/fixup-include/rdma-vmw_pvrdma-abi.h to the other patch.
> >
> > Then the description of the abi.h patch would just be:
> >
> > 'Update rdma-core to the latest kernel pvrdma-abi.h header'
> >
> > Then everything is more self contained.
> >
> > You can do this and force push a update to your PR.
>
> Got it, I've done a force push with the new commits. There were two
> other items that were in the kernel ABI header and not in the
> fixup-include header, so I've also fixed that.
>
> Unfortunately, I also missed adding the macro I am testing for in
> RDMA_LinuxHeaders.cmake in the kernel ABI header ): so I sent out a
> patch to fix that. This should not be a problem, as the test for
> PVRDMA_UAR_SRQ_OFFSET will make sure we use the header from
> fixup-include for now, until the kernel patch is accepted.

No, it is a problem.
You sent two patches, while the PR passes the compilation on my machine,
the first patch alone doesn't.

Every patch should be standalone.

Please fix.

>
> Going forward, I'll copy the ABI header file to make sure they are
> synced up and I don't make this mistake again.
>
> Thanks!
> Bryan
>
> >
> > Jason

--pVyBEWmAlQI22d4i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloNIE8ACgkQ5GN7iDZy
WKexzQ/+JFWbBjAazafcQ5jgMcbrJXyvqxIoJOAFGznuozE1WZf2BPN1+FNjVVxO
ejgS8Af2c2+nbEsowJgcgthLJkewO0U4W4Z5ilQ+7cAzKMg/kSYtu0xzTQ2/gZJa
JgCnq15fp0b7zG+uRWsImr6v1V+sLEr7p8dpOH+qBh5Mb5z5+H8EP5YE2gsdJs3l
YUZBV/dwrssAEjRDbVaDfmbFEpj74MKLxW1llmc+LSyR8F8OBn5Kr2Kl5MfpsFxv
J2FfJM24cM9m6tiPFU3/92VTSdbbmSwhWB6BBM+pd5Tof7kaNxsVo6xHAsPackOt
zhQs4vykRUUjH6AjzoWVWETSbQ919ps1X1wyKY+v+eBTIYahaPOzxKQIYtM2YKGZ
+j8WOOZEnXo8lCPFmSYoAF0qBEJcOeJAdzbfxU0XytPtw4geWMTgH9M21yOI9wSn
v9az5jwcAlDZPzubLl2/UxpFIyPYb+5bbg3s4wCODQ0WCzGDpqmJYversyK/oyl/
lXyD/mJpYPG9V2OCjMqDP/ORQO+qDfNGvz5FPO6Mz1xUeGihdciZzUjg0VfRbm3P
IAkU7UyBAKUfoBLUi9cIyPKxTFzfdLer0b8JKdgdEPuYIximt6egeE3l30cCgYLU
UohOPO3/H3PtMIjYvKl/wMzuRkhwEQSEip05xU9Td4LWI+D6m1s=
=GZFQ
-----END PGP SIGNATURE-----

--pVyBEWmAlQI22d4i--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
