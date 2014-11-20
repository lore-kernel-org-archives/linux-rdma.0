From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Thu, 20 Nov 2014 13:21:13 +0200
Message-ID: <546DCEA9.7010506@mellanox.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com> <1416312682-7899-2-git-send-email-yishaih@mellanox.com> <546CADEF.6070905@mellanox.com> <546D9DB2.8050900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546D9DB2.8050900-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/20/2014 9:52 AM, Yishai Hadas wrote:
>> can we avoid the fatal_event_raised flag?
>
> We need this flag to prevent generating duplicate event. This may 
> happen when a fatal error occurred and just later the remove one was 
> called when there were active applications.

If your only concern is not generating duplicate fatal error events, I 
would strongly recommend to go a drop this flag to make the code 
clearer/simpler, object->I_already_did_operation_X flags should be 
avoided in correct system programming IMHO.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
