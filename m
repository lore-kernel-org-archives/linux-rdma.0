From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows
 the klms[] array
Date: Wed, 26 Apr 2017 15:05:25 +0000
Message-ID: <1493219124.2632.2.camel@sandisk.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com>
         <20170425175849.GS14088@mtr-leonro.local>
         <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com>
         <1493177952.3503.1.camel@sandisk.com>
         <1801288254.2280763.1493207193850.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1801288254.2280763.1493207193850.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <8FF3A6750D54CE459EA2B274FFFF8F5D-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-04-26 at 07:46 -0400, Laurence Oberman wrote:
> Its the same target that is stable for all other tests.
> This is the same issue I originally reported when we then reverted the SG=
+GAPS.
> Remember when I reverted that we were stable again.
>=20
> This happens on the initiator first
>=20
> [...]
>=20
> Only afterwards do I see the target complain
>=20
> [...]

Thanks Laurence. I think this confirms that we have to continue analyzing t=
he
initiator side further.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
