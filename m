From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: rdma-core out-of-tree user library
Date: Tue, 6 Jun 2017 12:49:21 +0000
Message-ID: <BN3PR07MB25781554943206E577DFC714F8CB0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason, Leon, Doug, All,
A provider's out-of-tree user library cannot be built against rdma-core, be=
cause the
API is hidden to out-of-tree libraries. This was due to a decision taken mo=
nths back.
The distros have adopted this approach as-is and it is going to be part of =
the next
releases. While this approach ensures all of the components are in-sync, it=
 has its
disadvantages.

There is typically a gap of several months between two inbox releases.
New features and fixes are delivered to the next inbox releases, but we wou=
ld like to
have the ability to supply an outbox user library to customers in between. =
It may
also happen that customers can only adopt the new inbox version with a dela=
y, or even
worse, if they cannot adopt it at all due to various reasons.

I guess this is something you have thought of. If so, what were/are your th=
oughts about
creating intermediate out-of-box versions?

How are other providers handling this?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
