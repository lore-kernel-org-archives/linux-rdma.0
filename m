From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Socket Direct Protocol: help (2)
Date: Tue, 13 Apr 2010 13:22:40 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
 <4BC49E2B.3000804@opengridcomputing.com>
 <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
 <4BC4D22A.6020700@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BC4D22A.6020700-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "mingo-X9Un+BFzKDI@public.gmane.org" <mingo-X9Un+BFzKDI@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>> Chien, does the NE020 support FMRs?  I looked at the nes ofed-1.5 code
>>> and it appears to do nothing in the map_phys_fmr functions.
>>>
>>
>> We never implemented map_phys_fmr.  Is it relevant to the # of SGEs?
>>
>No, but SDP uses FMRs.  I don't think it will run without FMR support.
>


Good to know.  Thanks.

Chien


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
