From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Thu, 13 Jun 2013 17:35:39 +0200
Message-ID: <51B9E6CB.40607@profitbricks.com>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org> <51B9CFC3.8080008@profitbricks.com> <51B9E046.3030008@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B9E046.3030008-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13.06.2013 17:07, Bart Van Assche wrote:
[...]
> The "%.*s" should only copy the data provided by the user, even if it
> is not '\0' terminated. Stripping the trailing newline is probably
> possible with something like the (untested) code below (will only work
> if there is only one newline in the input string and if it's at the
> end):
> 		shost_printk(KERN_INFO, target->scsi_host,
> 			     PFX "Already connected to target port %.*s\n",
> 			     (int)count - (memchr(buf, '\n', count) ==
> 					   buf + count - 1), buf);

I thought more like this existing message (as the input string by the
user is possibly long with a lot of configuration options):

shost_printk(KERN_DEBUG, target->scsi_host, PFX
	     "new target: id_ext %016llx ioc_guid %016llx pkey %04x "
	     "service_id %016llx dgid %pI6\n",
	(unsigned long long) be64_to_cpu(target->id_ext),
	(unsigned long long) be64_to_cpu(target->ioc_guid),
	be16_to_cpu(target->path.pkey),
	(unsigned long long) be64_to_cpu(target->service_id),
	target->path.dgid.raw);

But this thing takes a lot of code lines. Perhaps this string formatting
should be put into a macro/inline function then.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
