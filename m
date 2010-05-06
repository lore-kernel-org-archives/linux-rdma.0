From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 2/3] ib/iser: remove buggy back-pointer setting
Date: Thu, 06 May 2010 12:09:45 -0500
Message-ID: <4BE2F7D9.5060605@cs.wisc.edu>
References: <Pine.LNX.4.64.1005051726110.29957@zuben.voltaire.com>	<Pine.LNX.4.64.1005051730170.29957@zuben.voltaire.com> <4BE1AFF4.30600@cs.wisc.edu> <4BE27CB1.5000609@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BE27CB1.5000609-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/06/2010 03:24 AM, Or Gerlitz wrote:
> Mike Christie wrote:
>> I agree on it being a bug, but do you remember why that was added to iscsi_iser_conn_destroy originally?
>> I later moved it to iser_conn_release in commit b40977d95fb3a1898ace6a7d97e4ed1a33a440a4)
>> but I think Erez had added that null and some checks for it being null for a specific bug.
>> I am not 100% sure. Look in the git logs to make sure. I will check them too when I get some more time.
>
> Mike, I took a look on the git, in commit 87e8df7a273c7c1acb864c90b5253609c44375a6 "Have iSER data transaction object point to iSER conn", Erez added these two chunks,
>
>> @@ -317,6 +317,8 @@ iscsi_iser_conn_destroy(struct iscsi_cls_conn *cls_conn)
>> +       if (iser_conn->ib_conn)
>> +               iser_conn->ib_conn->iser_conn = NULL;
>
>
>> @@ -571,6 +571,8 @@ void iser_conn_release(struct iser_conn *ib_conn)
>> +       if (ib_conn->iser_conn)
>> +               ib_conn->iser_conn->ib_conn = NULL;
>
> The problem he was trying to solve was related to the processing of RX/TX buffers flushed by the QP throughout the disconnection flow, so he was shutting down the UP/DOWN pointers.
>
> Later in commit b40977d95 you touched the UP NULL-ing, leaving it in different form. I don't see any specific reason to have the buggy DOWN NULL-ing in iser_conn_release, I believe it doesn't solve any problem and adds a bug, this is what my patch comes to solve, okay?
>

Yeah, sounds good. Thanks for looking that up.

I thought it was for some case where iscsid was confused, but it looks 
like I was wrong (I also double checked userspace to see if we had a bug 
that cause a need and did not see one) so add my:

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
