From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 8/8] IB/core: extended command: move
 comp_mask to the extended header
Date: Tue, 05 Nov 2013 10:20:27 +0100
Message-ID: <1383643227.18301.50.camel@localhost.localdomain>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
	 <1383126771-7658-9-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126771-7658-9-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Matan,

Le mercredi 30 octobre 2013 =C3=A0 11:52 +0200, Matan Barak a =C3=A9cri=
t :
> From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
>=20
> The unused field in the extended header is a perfect candidate
> to hold the command "comp_mask" (eg. bit field used to handle
> compatibility). This was suggested by Roland Dreier in a previous
> review[1].
>=20
> So this patch move comp_mask from create_flow/destroy_flow commands
> to the extended command header. Then comp_mask is passed as part
> of function parameters.
>=20

As I wrote in a previous mail, I think this "comp_mask" should not be
handled specificaly since a "comp_mask" might be also needed for the
"provider"=20

So I'm now in favor of dropping this patch and adding a note in the
patch which update the framework about the usage of "comp_mask" in each
part of the command/response.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
