From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Wed, 10 May 2017 16:46:42 +0000
Message-ID: <1494434801.2578.13.camel@sandisk.com>
References: <1494349653.3752.4.camel@profitbricks.com>
         <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
         <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
         <20170509180159.GK10073@mtr-leonro.local>
         <1494423046.3739.8.camel@profitbricks.com>
         <22803.7541.113159.214164@gargle.gargle.HOWL>
         <1494432414.2578.9.camel@sandisk.com>
         <22803.16933.196383.482890@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22803.16933.196383.482890-4mDQ13Tdud8Jw5R7aSpS0dP8p4LwMBBS@public.gmane.org>
Content-Language: en-US
Content-ID: <4819313F9BF5AF45BD510AB2B8F4D2A4-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org" <rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-10 at 18:39 +0200, Roland Fehrenbacher wrote:
> The new package is very new, sits in debian unstable and most likely
> hasn't made it to Ubuntu 17.04.

Hello Roland,

Does that mean that most Debian users do not yet have that change in their
/etc/srp_daemon.conf and when they upgrade and the packaged version of
/etc/srp_daemon.conf gets installed that SRP login to remote systems will
not occur anymore after a reboot? Since you wrote in a previous message
that such changes are mentioned in the NEWS file: how many people do you
think read that file before or after installing an upgrade?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
