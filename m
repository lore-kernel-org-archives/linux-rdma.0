From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: SQ overflow seen running isert traffic with high block sizes
Date: Wed, 28 Jun 2017 11:29:19 +0000
Message-ID: <BN3PR07MB25783736A155DEC2FD4B7A8DF8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170628103505.GA27517@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170628103505.GA27517-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Here is some more discussion regarding SQ overflow.
> https://www.spinics.net/lists/linux-rdma/msg47635.html
>=20
> Current SQ overflow handling is post error handling to keep the IO runnin=
g and
> We still see SQ post failures filling the dmesg.
> We are still working on fixing SQ overflow.
>=20
> Thanks,
> Bharat.

That's good to know.
Let us know when you have something working, we can help test it too.

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
