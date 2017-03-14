From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Tue, 14 Mar 2017 11:33:36 -0400
Message-ID: <1489505616.2217.58.camel@redhat.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
         <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
         <20170306180723.GD11805@obsidianresearch.com>
         <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
         <20170307181738.GC2228@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307181738.GC2228-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-03-07 at 11:17 -0700, Jason Gunthorpe wrote:
> Using the dv interface should be obvious and *always* create a
> link-time dependency on the driver. If someone doesn't want to do
> that
> then they shouldn't use the interface.
> 
> This makes it very clear to the user that they are touching a
> non-portable API and they need to plan accordingly.

As far as I'm concerned, this is probably the most important argument
made so far in this thread.  So, Yishai, to answer your question, I'm
in agreement with Jason and Sean.  The flexibility that you are so fond
of in the original patch submission sounds nice, but it leads to all
sorts of problems.  Better to have a more rigid, typed interface than
something that people can't understand how to use by looking at it.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
