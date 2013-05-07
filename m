From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: decent performance drop for SCSI LLD / SAN initiator when iommu
 is turned on
Date: Tue, 7 May 2013 17:50:01 +0300
Message-ID: <CAJZOPZ+Ofir1u8AbdMoXaujQZJe4D1Ly18B4+NJZ9L0GVUp90Q@mail.gmail.com>
References: <CAJZOPZJ8eF-Q+WFzA-_vvzkpSb41PQjKFo27_Wi3McUccOqs9A@mail.gmail.com>
	<20130502015603.GC26105@redhat.com>
	<CAJZOPZLWgXNCEpZjzuizVGPEVPg1G+cHh373ZCoumMx9eAabvQ@mail.gmail.com>
	<5188304E.9050603@intel.com>
	<20130507122235.GA21361@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130507122235.GA21361-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Asias He <asias-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 7, 2013 at 3:22 PM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> But why isn't iommu=pt effective?
> AFAIK the whole point of it was to give up on security
> for host-controlled devices, but still get a
> measure of security for assigned devices.


Good questions, from the tests Yan did so far he didn't see that this
yields improvement for the iSER
SCSI driver, didn't try it yet with netdevice, Alex/Asias did you
tried that option? any conclusions?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
