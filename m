From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Wed, 22 Oct 2014 07:54:59 +0300
Message-ID: <544738A3.7070605@mellanox.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>	<543CD5D6.1020506@mellanox.com>	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>	<5443DBCA.4000002@dev.mellanox.co.il>	<ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>	<CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA@mail.gmail.com>	<eaf7c875-e7e1-43eb-b27a-fbd068aa32f1@CMEXHTCAS1.ad.emulex.com>	<CAJ3xEMgnmZD8ONJcnor__eioMtfaO6MYMKfd6nbXncaWYXTG+g@mail.gmail.com> <CAJ3xEMi9uBB0fFqGj4nUOdYYezLzF135TLH-sswQ0G5hZQvAkA@mail.gmail.com> <54466C39.4070402@mellanox.com> <d89b8c11-5f4f-4a70-b2de-3342c6b628a8@CMEXHTCAS2.ad.emulex.com> <54472C2A.7060407@mellanox.com> <340a8ae7-4597-4514-a69d-9ef0d56a7e6e@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <340a8ae7-4597-4514-a69d-9ef0d56a7e6e-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 10/22/2014 7:29 AM, Minh Duc Tran wrote:
> Not just that one liner change.  The change is about 10 lines and very simple.  It should take you about 30 seconds to read it.  We need the whole patch to fix two problems:
> 1) the create CQ failure due to requested CQ entries too large.
> 2) the create qp failure due to requested wr entries too large.  Our hw has a limit of around 2k wr per qp in this profile.  Iser calls to create qp with a hardcoded value of around 4k.
OK, got it.

>
> If you have other ideas how to solve our problem, please let us know.

So let's max the QP size too against the device. The large QP size 
originates from what does it take to support unsolicited data outs, so 
in your case, you can document some sort of limitation in that respect 
for 3.18 and we'll do a full features proofed solution for 3.19. Please 
send the minimal patch for these two fixes on a new thread and we'll 
pick it up.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
