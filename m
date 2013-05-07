From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: decent performance drop for SCSI LLD / SAN initiator when iommu
 is turned on
Date: Tue, 7 May 2013 15:12:29 +0300
Message-ID: <5188EFAD.50708@mellanox.com>
References: <CAJZOPZJ8eF-Q+WFzA-_vvzkpSb41PQjKFo27_Wi3McUccOqs9A@mail.gmail.com> <20130502015603.GC26105@redhat.com> <CAJZOPZLWgXNCEpZjzuizVGPEVPg1G+cHh373ZCoumMx9eAabvQ@mail.gmail.com> <5188304E.9050603@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5188304E.9050603-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Asias He <asias-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/05/2013 01:35, Alexander Duyck wrote:
> The Tx path ends up taking a performance hit if IOMMU is enabled.  It
> just isn't as severe due to things like TSO.

In testing done by some Mellanox folks I think they see major penalty on 
the RX side, but hardly
nothing on the TX side, I'll check that.

> One way to work around the performance penalty is to allocate bounce
> buffers and just leave them static mapped.  Then you can simply memcpy
> the data to the buffers and avoid the locking overhead of
> allocating/freeing IOMMU resources.  It consumes more memory but works
> around the IOMMU limitations.

I don't think can be applicable approach to fast networking/storage drivers.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
