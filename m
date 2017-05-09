From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Tue, 9 May 2017 17:54:33 +0000
Message-ID: <1494352472.2518.10.camel@sandisk.com>
References: <20170507064349.GM22833@mtr-leonro.local>
         <1494351789.3752.5.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494351789.3752.5.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Content-ID: <4317D8C6D0C39A4988DB346564A77B97-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-05-09 at 19:43 +0200, Benjamin Drung wrote:
> Am Sonntag, den 07.05.2017, 09:43 +0300 schrieb Leon Romanovsky:
> * Can we upstream some redhat files, i.e. move them out of the redhat
> directory and maintain them in their corresponding code? Following
> files fall in this category:
> ** ibacm.service
> ** srp_daemon.service
> ** rdma service (see next point)

One of the design goals of the systemd project was to avoid that different
service files would be needed for different distro's. So I think it's weird
that these service files exist in the redhat/ directory.

>   I: srptools: init.d-script-does-not-implement-optional-
>      option=A0etc/init.d/srptools status
>=20
> I can write that if you decide not to consolidate the srp daemon (see
> bonus point below)

I will submit a patch.

> *=A0Bonus points: consolidate the srp daemon. Debian ships a different
> service file than upstream, but I am against an additional layer
> introduced by srp_daemon.sh. It would also be nice to have a systemd
> service shipped by upstream (and not just in the redhat directory)

I will have a look at this too.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
