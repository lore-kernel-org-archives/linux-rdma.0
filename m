From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: IB/ipoib: fix dangling pointer reference to ipoib_neigh and ipoib_path
 -when will it go upstream?
Date: Tue, 13 Jul 2010 19:54:08 -0700
Message-ID: <4C3D26D0.3090508@linux.vnet.ibm.com>
References: <4C3AA0A2.3090406@linux.vnet.ibm.com> <adapqysxup6.fsf@roland-alpha.cisco.com> <4C3C02B2.9040408@linux.vnet.ibm.com> <adaeif7xwwz.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaeif7xwwz.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > I guess I came to a premature conclusion. One set of tests ran fine and I made that
>  > conclusion. Another set of tests caused the following crash:
> 
> I don't really know how to interpret this.  Is this crash new, or is it
> the same crash you were hoping this patch fixed?

This is a new crash.

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
