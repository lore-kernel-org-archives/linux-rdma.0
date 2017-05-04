From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH RFC 02/10] IB/core: Add support to finalize objects in one
 transaction
Date: Thu, 4 May 2017 14:50:19 +0000
Message-ID: <SN1PR07MB22077A1B43881BAF7BAC5ED0F8EA0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1492615225-55118-1-git-send-email-matanb@mellanox.com>
 <1492615225-55118-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492615225-55118-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The new ioctl based infrastructure either commits or rollbacks
> all objects of the command as one transaction. In order to do
> that, we introduce a notion of dealing with a collection of
> objects that are related to a specific action.
>=20
> This also requires adding a notion of an action and attribute.
> An action contains a groups of attributes, where each group
> contains several attributes.
>=20
> When declaring these actions and attributes, we actually declare
> their specifications. When a command is executed, we actually
> allocates some space to hold auxiliary information.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Matan, thanks for the RFC!

If I got this correctly each object will go through three phases - get, han=
dler, and a put.
I don't quite understand how a batch operation, like destroy QPs, can be un=
done after the handler phase.
I do see it working if at first multiple gets are performed and one of them=
 fails.
In that case undoing is easy because the handlers weren't invoked yet.

In the case were some user-objects failed the operation how is this reflect=
ed upwards?

Also, I wonder, is there another intention behind batch operations except s=
peed?


Thanks,
Ram
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
