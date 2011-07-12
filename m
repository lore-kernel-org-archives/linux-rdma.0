From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: install.pl "chown" issue (Was: Re: rhel6 ofed v1.5.3)
Date: Tue, 12 Jul 2011 10:14:33 -0700
Message-ID: <20110712101433.a0da6a3f.weiny2@llnl.gov>
References: <BANLkTi=fJr7BypNCs-7S4-THNTUGtmiicg@mail.gmail.com>
	<20110705153618.c7cba778.weiny2@llnl.gov>
	<CABOsP2MbNq6Yqc6+DKes==gim1dk3oipCL6H5zN6EiMGJhOCOg@mail.gmail.com>
	<CABOsP2NfGia2dNjxfdeG4SSRymbPSD+f1QzWPW_zKRw9PPU_rw@mail.gmail.com>
	<CABOsP2PX-OSVBOMQ_fFv_bLApxZaUfr8_pA49FgDGTGHUZWBDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABOsP2PX-OSVBOMQ_fFv_bLApxZaUfr8_pA49FgDGTGHUZWBDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Mon, 11 Jul 2011 07:42:38 -0700
Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Jul 11, 2011 at 9:43 AM, Michael Di Domenico
> <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Mon, Jul 11, 2011 at 9:28 AM, Michael Di Domenico
> > <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> On Tue, Jul 5, 2011 at 6:36 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> >>> On Fri, 1 Jul 2011 10:08:47 -0700
> >>> Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>>
> >>>> According to my installation of Ofed 1.5.3 on RHEL6, the
> >>>> infiniband-diags package rpm is trying to chown /usr/local in or=
der to
> >>>> deposit a library in lib64.
> >>>
> >>> infiniband-diags does not do a chown.
> >>
> >> Sorry for the late reply, your reply got lost in my email bins...
> >>
> >> I should correct my statement, when RPM does the cpio extraction o=
f
> >> the data that's what's reporting the error
> >>
> >>>> In my environment /usr/local is off-limits to root and all packa=
ge
> >>>> installs. =A0Is this a bug? =A0Is there a workaround to allow th=
e
> >>>> install.pl to complete?
> >>>
> >>> I just tried this on a vanilla Fedora 15 system and was able to b=
uild the source rpms just fine.
> >>>
> >>> Try building and installing in this order.
> >>>
> >>> libibumad-1.3.7-1.src.rpm
> >>> libibmad-1.3.7-1.src.rpm
> >>> opensm-3.3.9-1.src.rpm
> >>> infiniband-diags-1.5.8-1.src.rpm
> >>
> >> these all build correctly using the install.pl file upto the
> >> infiniband-diags file then i get
> >>
> >> error: unpacking archive file on file /usr/local: cpio: Operation =
not supported
> >>
> >
> > the file that seems to get included in the rpm is
> >
> > /usr/local/lib64/perl5/IBswcountlimits.pm
> >
> > i can't seem to locate where that's coming from though
>=20
> Looks like the spec file pulls the "installsitearch" from the perl
> config.  on redhat 5 there doesn't seem to be an installsitearch
> variable defined in the perl -V output, but on redhat 6 there is a
> -Dinstallsitearch=3D/usr/local/lib64
>=20
> this is a redhat 6'ism, i did a fresh install of rhel6.0 to test
> whether it was something i messed up in the perl or not, but it wasn'=
t
> me.
>=20
> i can likely work around the issue in the short term by recompiling
> the spec file by hand

You're right...  :-(  Sorry about that.

I spoke to some people here and our RedHat consultant.  I think this mo=
dule should be installed in vendorlib.  Would you agree?

Ira


--=20
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
