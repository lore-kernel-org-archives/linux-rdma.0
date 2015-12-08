From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/10] IB/qib: Use rdmavt protection domain
Date: Tue, 8 Dec 2015 18:14:02 -0500
Message-ID: <20151208231401.GC14221@phlsvsds.ph.intel.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com> <20151207204901.11219.30885.stgit@phlsvslse11.ph.intel.com> <CAG9sBKNHOugvAoKYfJpvNorJR2Jih13+aeGPj0N6jVQRgBwL0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNHOugvAoKYfJpvNorJR2Jih13+aeGPj0N6jVQRgBwL0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 12:49:59PM +0200, Moni Shoua wrote:
>On Mon, Dec 7, 2015 at 10:49 PM, Dennis Dalessandro
><dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Remove protection domain datastructure from qib and use rdmavts version.
>>
>I failed to apply this patch
>tried with rc3 and rc4

Perhaps the two patches I mentioned in the cover letter to fix the 
regressions are required. I didn't think they were. Regardless I'll rebase 
onto Doug's latest branch for 4.5 in the next version of this patch series 
and ensure it all applies cleanly.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
