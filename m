From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [1/1] mm: thp: calculate the mapcount correctly for THP pages during WP faults
Date: Wed, 11 May 2016 17:26:16 -0400
Message-ID: <20160511212552.GA20578@phlsvsds.ph.intel.com>
References: <1462908082-12657-1-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462908082-12657-1-git-send-email-aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>
>Reviewed-by: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
>Signed-off-by: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Our RDMA tests are seeing an issue with memory locking that bisects to
commit 61f5d698cc97 ("mm: re-enable THP").

The test program registers two rather large MRs (512M) and RDMA writes
data to a passive peer using the first and RDMA reads it back into the
second MR and compares that data.  The sizes are chosen randomly betwee=
n
0 and 1024 bytes.

The test will get through a few (<=3D 4 iterations) and then gets a com=
pare error.

Tracing indicates the kernel logical addresses associated with the indi=
vidual
pages at registration ARE correct , the data in the "RDMA read response=
 only"
packets ARE correct.

The =E2=80=9Ccorruption=E2=80=9D occurs when the packet crosse two page=
s that are not
physically contiguous.   The second page reads back as zero in the prog=
ram.

It looks like the user VA at the point of the compare error no longer p=
oints
to the same physical address as was registered. =20

This patch totally resolves the issue!

Tested-by: Mike Marciniszyn <mike.marciniszy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Josh Collier <josh.d.collier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
