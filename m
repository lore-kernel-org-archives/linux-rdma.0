From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/7] Add support for OPA classport info
Date: Fri, 28 Apr 2017 14:10:17 -0400
Message-ID: <1493403017.3041.166.camel@redhat.com>
References: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-20 at 19:38 -0400, Dasaratharaman Chandramouli wrote:
> This series moves the classport info query initiation and update
> from callers such as ipoib to the ib_sa module itself. The classport
> info cache is updated whenever ib_sa receives an appropriate state
> change event.
> 
> Since classport info is only used to check if sendonly full member
> support
> is enabled by the SM, we expose a function
> ib_sa_sendonly_fullmem_support
> that can be called to check if the support is enabled. 
> 
> Additionally, we introduce support for opa classport info. These are
> defined specifically for OPA devices and expose additional features
> in the
> capability mask bits along with longer LID sizes in some of the other
> fields.
> 
> Patch 1 to 3 fix checkpatch issues (1 issue type per patch) on two
> functions that patch 4 then moves around. Patch 5 makes changes
> to implicitly query and cache classport info. Patch 6 adds 
> verbs capability API for core layers to query and find out if they
> are running on an OPA device. Finally, patch 7 adds OPA classport
> info
> query support.

I took patches 1-6 of this series.  However, I need you to rebase patch
7 against my current k.o/for-4.12-rdma-netdevice branch as there are
significant conflicts between this and the VNIC patches I've already
taken.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
