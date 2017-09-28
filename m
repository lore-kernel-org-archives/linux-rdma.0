From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Thu, 28 Sep 2017 19:47:35 +0300
Message-ID: <20170928164735.GC2297@mtr-leonro.local>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170928163406.GB17880@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJKqlw44nclc26Ih"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928163406.GB17880-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--IJKqlw44nclc26Ih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 10:34:06AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 27, 2017 at 12:32:48PM +0300, Yuval Shaia wrote:
> > The sysfs "create_child" interface creates pkey based child interface but
> > derives the name from parent device name and pkey value.
> > This makes administration difficult where pkey values can change but
> > policies encoded with device names do not.
> >
> > We add ability to create a child interface with a user specified name and a
> > specified pkey with a new sysfs "create_named_child" interface (and also
> > add a corresponding "delete_named_child" interface).
> >
> > We also add a new module api interface to query pkey from a netdevice so
> > any kernel users of pkey based child interfaces can query it - since with
> > device name decoupled from pkey, it can no longer be deduced from parsing
> > the device name by other kernel users.
>
> This should all use netlink these days, not more sysfs files.
>
> Leon? What do you think about using rdmatool to provide a command line
> for creating ipoib children?

As far as I understand ipoib_netlink.c, ipoib_new_child_link() already
implements it and it is supported in "ip".

And I think that it is more netdev than rdma, so IMHO, the "ip" is more
appropriate, but if someone decides to add "ipoib" object in rdmatool,
I won't stand against it.

>
> > +  Interfaces with a user chosen name can be created in a similar
> > +  manner with a different name and P_Key, by writing them into the
> > +  main interface's /sys/class/net/<intf name>/create_named_child
> > +  For example:
> > +     echo "epart2 0x8002" > /sys/class/net/ib1/create_named_child
>
> 'multi-value' sysfs files like this are categorically banned by Greg.
>
> Any kind of configuration in sysfs is really frowned on these days.
>
> Jason

--IJKqlw44nclc26Ih
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnNJ6cACgkQ5GN7iDZy
WKePdRAAuecNuxYC5HjZ00TJuhYqlGOgQUfh8Y3muGzLZI7fHNk1cJuN4A4syZG0
bAQApqHDw8FFSjg1uOvkcD8XT2MgmvRDNdPYb8BCuHY2Mwx8dGo+gI5f2WooFClh
kgKDUF2aobyLsNYmQ9bOuaTfY32waXyYfPr9FZrrDR3xYN6I9hhJulgdM+sMZgLa
ZpLNFNOxRRWB+25ws+P3sQZP+HMBROU/6RAowz6skzkyUhgZSzeINYlp4dLrMBto
3CTBm69yvfmfzfGB38aSfw8jlamY+tw3E3+m9QcMY/Co0IC4LbKIaevdO0j41AC2
azalrX/VVAD7o2jon9lcm3/3u1IjbHiMV5QqjZmmJFJpAq16VtllZ5ucUUidTDGo
fXnx3ujgzbHN1d2k14uUlBy2nKkc8QJ/zU7vKW/4C6RbbhLuvzdi+Ej1GUyMmpx8
AgRNS5n1i3IgkPjdEhlJFfj6nMB1+a9Ho25BQr1mALqbOLpsH5wzN8OMa8cAZbd8
/DJoHQUD3/qZA0L6TAnpHt6mLak/hh3JVLHsMPzlDnQKM47RTEOzpeR2vBk1SWkm
+ykfuot6b/dpRuKXo+FWywIONBQa4bZh2FL81Xc2bgZmmRzoQKqNJmOYWGqHjK7g
2WgZZtjk8lLWfzUj5A5h33FY0xiQ0iqH22kwtsroibha37bApyw=
=hDNq
-----END PGP SIGNATURE-----

--IJKqlw44nclc26Ih--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
