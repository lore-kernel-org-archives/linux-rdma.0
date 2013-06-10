From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: How to do replication right with SRP or remote storage?
Date: Mon, 10 Jun 2013 14:44:35 +0200
Message-ID: <51B5CA33.70006@acm.org>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org> <loom.20130608T041932-498@post.gmane.org> <51B5C108.1030803@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B5C108.1030803-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bruce McKenzie <sales-uUyUjRhFbRmVZhT2dXthUg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/10/13 14:05, Sebastian Riemer wrote:
> Perhaps, I should collect all guys who require MD RAID-1 for remote
> storage replication in order to put some pressure on Neil.

If I remember correctly one of the things Neil is trying to explain to 
md users is that when md is used without write-intent bitmap there is a 
risk of triggering a so-called write hole after a power failure ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
