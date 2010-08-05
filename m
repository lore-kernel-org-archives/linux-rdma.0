From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: InfiniBand/RDMA merge plans for 2.6.36
Date: Thu, 5 Aug 2010 14:19:53 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443B50B5FD12@MTLMAIL.mtl.com>
References: <adak4o654x9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4o654x9.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/5/2010 2:33 AM, Roland Dreier wrote:

Hi Roland,

>
> Here are a few topics I'm tracking that are not ready in time for the
> 2.6.36 window and will need to wait for 2.6.37 at least:
>
>  - XRC.  While I think we made significant progress here, the fact is
>    that this is not ready to merge at the beginning of the merge
>    window, and so we'll need to keep working on it and wait for the
>    next merge window.  I think this is just blocked on me at the
>    moment.
Jack did all the changes you asked for and submitting the V3 patches on 2010/05/19, 
which was long enough before the window.
What is the reason it will not be part of 2.6.36 kernel?

>
>  - IBoE.  Same as XRC; we made significant progress (and I opened an
>    iboe branch to track this), and I think we have finally gotten the
>    user-kernel interface nailed down yet, but it's just too late.
Eli sent the user space patch that was the last technical debate last week. 
He will also send a new patch-set in day or two.
This feature was under a lot of technical review from the community.
Please consider including it in 2.6.36 after all.
 
In general - none of our new features going to be included and I wish to understand the reason behind it (I hope it's not personal :-)

regards
Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
