From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 15/24] IB/srp: Convert to new memory registration API
Date: Tue, 22 Sep 2015 14:58:56 -0700
Message-ID: <5601CF20.3040102@sandisk.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <1442482947-27785-16-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442482947-27785-16-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/17/2015 02:42 AM, Sagi Grimberg wrote:
> Since SRP supports both FMRs and FRWR, the new API conversion
> includes splitting the sg list mapping routines in srp_map_data to
> srp_map_sg_fr that works with the new memory registration API,
> srp_map_sg_fmr which constructs a page vector and calls
> ib_fmr_pool_map_phys, and srp_map_sg_dma which is used only
> if no FRWR nor FMR are supported (which I'm not sure is a valid
> use-case anymore).
>
> The srp protocol is able to pass to the target multiple descriptors
> for remote access, so it basically calls registers muleitple sg list
> partials the entire sg list is mapped and registered (each time maps
> a prefix of an sg list).

This sentence is hard to comprehend, and the spelling of "multiple" 
should be addressed.

Another comment about this patch is that there are multiple changes in 
this patch. It should be split into multiple patches, e.g. one patch 
that converts srp_map_sg() into srp_map_sg_fmr() and srp_map_sg_fr() and 
another patch that introduces the ib_map_mr_sg() call.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
