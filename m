From: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/iser: re-adjust number of max_cqe and send_wr to
 hw supported number.
Date: Mon, 27 Oct 2014 05:01:43 +0000
Message-ID: <f3c8d326-54a7-4c61-b940-6e2ba4c80a25@CMEXHTCAS1.ad.emulex.com>
References: <2cee0ee5-dd62-451a-a6a9-a237b59e8dd1@CMEXHTCAS1.ad.emulex.com>
 <544CDD66.3030303@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <544CDD66.3030303-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>This looks better, but I have a couple of comments (below).
>I can modify those and add it to a couple of patches I have piped for 3.18-rcX.

Thanks for the prompt review of the patch.

>So I see this as a temp fix for now. A more thorough fix will follow in 3.19.

I like to follow up with all IB/iser changes and developments for 3.19.  Please keep me updated with these changes if they are not going to be in the RDMA mailing list.

>Can you try the patch attached with my bits modified?

>Thanks,
>Sagi

Your modification to the patch looks good and ran as expected.

-Minh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
