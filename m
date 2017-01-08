From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/2] IB/core: add the function ib_mtu_int_to_enum
Date: Sun, 8 Jan 2017 10:36:45 +0000
Message-ID: <SN1PR07MB22075B9FBE007701AB91967AF8650@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
 <1482734458-32131-2-git-send-email-Ram.Amrani@cavium.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0CE4E4@ORSMSX109.amr.corp.intel.com>
 <SN1PR07MB2207C1F332D441FECD65C3F8F8610@SN1PR07MB2207.namprd07.prod.outlook.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0CE998@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0CE998-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The enum values are IB specification specific, and are incomplete (note t=
he
> lack of Ethernet mtu sizes).  Let the IB centric code deal with the conve=
rsion,
> and let the rest of the API be reasonable.  The IB CM uses the mtu value =
in
> the path record, which is fine.  Then maybe someday userspace can get
> access to the real mtu sizes as well...

I was delaying my response to let others post their opinion, which didn't h=
appen.
This tiny patch just reduced code size, not more.
I suggest you re-open a discussion on a dedicated thread to get a wider vie=
w, or
come up with suggestion patch.

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
