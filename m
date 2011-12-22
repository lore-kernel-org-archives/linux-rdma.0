From: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
Date: Thu, 22 Dec 2011 14:52:30 -0500
Message-ID: <7831.1324583550@turing-police.cc.vt.edu>
References: <1324430940.2844.144.camel@deadeye> <1324431127.2844.146.camel@deadeye>
            <1324434950.14214.3.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1324583550_2451P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Your message of "Tue, 20 Dec 2011 18:35:50 PST."
             <1324434950.14214.3.camel@joe2Laptop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--==_Exmh_1324583550_2451P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Dec 2011 18:35:50 PST, Joe Perches said:
> On Wed, 2011-12-21 at 01:32 +0000, Ben Hutchings wrote:
> > Physical addresses may be wider than virtual addresses (e.g. on i386
> > with PAE) and must not be formatted with %p.
> []
> > The resource could alternately be formatted with %Pr.

> Probably should be unsigned long long

I don't have a dog in this fight, but the %Pr sounds better to me.

--==_Exmh_1324583550_2451P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO84p+cC3lWbTT17ARAlyQAKD+hI0oj4y43ZHN4rB1YX9BZnXJIACfZqrh
D0CWeD2hmcN0W+pDpL0Owmk=
=HFH0
-----END PGP SIGNATURE-----

--==_Exmh_1324583550_2451P--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
