From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] IB/core: add the function ib_mtu_int_to_enum
Date: Wed, 4 Jan 2017 17:40:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0CE998@ORSMSX109.amr.corp.intel.com>
References: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
 <1482734458-32131-2-git-send-email-Ram.Amrani@cavium.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0CE4E4@ORSMSX109.amr.corp.intel.com>
 <SN1PR07MB2207C1F332D441FECD65C3F8F8610@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB2207C1F332D441FECD65C3F8F8610-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> You'll still be required to convert it to/from enum when
> building/parsing CM messages, for example.
> Also, why should it be an int if only specific values are allowed?

The enum values are IB specification specific, and are incomplete (note the lack of Ethernet mtu sizes).  Let the IB centric code deal with the conversion, and let the rest of the API be reasonable.  The IB CM uses the mtu value in the path record, which is fine.  Then maybe someday userspace can get access to the real mtu sizes as well...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
