From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Configure VF trust mode in 4.9
Date: Tue, 18 Apr 2017 19:39:29 +0000
Message-ID: <4911B4F2-1BA6-4E86-A6AD-E7A83DA78598@mellanox.com>
References: <CAANLjFoty0qrywFVSWC-LEbJw5LVvM8iN16t9nZaG+eDefA21A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoty0qrywFVSWC-LEbJw5LVvM8iN16t9nZaG+eDefA21A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Mohamad Haj Yahia <mohamad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 18, 2017, at 8:57 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>=20
> We have run across how to set the VFs on a ConnectX-4 adapter with
> OFED 3.3 [0]. We are trying to do this without OFED in the 4.9.21
> kernel. From what I can tell, the ability to add the appropriate rules
> into the on-card switch were added into 4.9-rc1
> (drivers/net/ethernet/mellanox/mlx5/core/eswitch.c). I just can't
> figure out how to enable the settings as the /sys paths don't exist
> and the `ip` command doesn't take the trust mode. Can someone give us
> a push in the right direction?
Added more people that can help..
>=20
> [0] https://community.mellanox.com/docs/DOC-2473
>=20
> Thanks,
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
