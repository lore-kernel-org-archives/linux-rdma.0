From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-next 2/9] IB/usnic: Fix format not a string literal
 warnings
Date: Sat, 21 Dec 2013 10:58:12 +0100
Message-ID: <52B56634.1020300@acm.org>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com> <1387298917-7365-3-git-send-email-umalhi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387298917-7365-3-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/17/13 17:48, Upinder Malhi wrote:
> Few printks in usnic are called w/o a string literal.
> Intel GCC is throwing warnings and this patch provides a fix
> for these.
> 
> [ ... ]
> @@ -372,8 +372,7 @@ static void usnic_ib_undiscover_pf(struct kref *kref)
>  		}
>  	}
> 
> -	if (!found)
> -		WARN("Failed to remove PF %s\n", pci_name(dev));
> +	WARN(found, "Failed to remove PF %s\n", pci_name(dev));
> 
>  	mutex_unlock(&usnic_ib_ibdev_list_lock);
>  }

The old code printed a warning if found == 0. The new code prints a
warning if found != 0. If this is on purpose I think this change should
be in a separate patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
