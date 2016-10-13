From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 07/32] srp_daemon: give initialize_sysfs a proper ANSI-C
 prototype
Date: Thu, 13 Oct 2016 12:05:36 -0700
Message-ID: <332952a7-64f5-c86e-b9ff-586acba6b5ac@sandisk.com>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
 <1476381095-20041-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-8-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/13/2016 10:51 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

This is something I had not yet noticed myself. I think this means we 
will need to enable more compiler warnings for srp_daemon such that gcc 
also catches this. Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
