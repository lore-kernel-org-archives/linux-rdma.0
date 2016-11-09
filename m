From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 9/9] selinux: Add a cache for quicker retreival of PKey
 SIDs
Date: Wed, 9 Nov 2016 14:03:33 +0000
Message-ID: <VI1PR0501MB24299AA647D26CF04F127059C4B90@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <1478639185-47521-1-git-send-email-danielj@mellanox.com>
 <1478639185-47521-10-git-send-email-danielj@mellanox.com>
 <20161109070455.GF27883@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/9/2016 1:05 AM, Leon Romanovsky wrote:=0A=
> On Tue, Nov 08, 2016 at 11:06:25PM +0200, Dan Jurgens wrote:=0A=
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>=0A=
>>=0A=
>> It is likely that the SID for the same PKey will be requested many=0A=
>> times. To reduce the time to modify QPs and process MADs use a cache to=
=0A=
>> store PKey SIDs.=0A=
>>=0A=
>> This code is heavily based on the "netif" and "netport" concept=0A=
>> originally developed by James Morris <jmorris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> and Paul Moore=
=0A=
>> <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> (see security/selinux/netif.c and=0A=
>> security/selinux/netport.c for more information)=0A=
>>=0A=
>> issue: 736423=0A=
>> Change-Id: I176c3079d5d84d06839b4f750100ac47a6081e94=0A=
> It doesn't belong to commit message.=0A=
>=0A=
>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>=0A=
=0A=
Yes, sorry silly oversight on my part.  I will address for all patches in v=
5.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
