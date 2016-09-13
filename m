From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RFCv3: Consolidated userspace RDMA library repo
Date: Tue, 13 Sep 2016 17:16:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB07FC3F@ORSMSX109.amr.corp.intel.com>
References: <20160907040925.GA27361@obsidianresearch.com>
 <2e2b54f5-1a9d-bb31-ffd9-fe6936011aaf@dev.mellanox.co.il>
 <20160908183122.GC21614@obsidianresearch.com>
 <fdbfdc86-80d2-bb12-e69a-d4b7976bfba6@dev.mellanox.co.il>
 <20160908193815.GA2424@obsidianresearch.com>
 <020b01d20a09$cb1ec320$615c4960$@opengridcomputing.com>
 <7df61de8-0999-1ba6-7381-be9753157650@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7df61de8-0999-1ba6-7381-be9753157650-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I think ofiwg is the official repo, and the other is his personal repo.
> Much like I use k.o as my official repo and github as my early release
> repo.

Correct.  I had manually merged patches sent into linux-rdma into my personal repo, and was just lacking the PR to merge those into the upstream repo.  I've merged the pending changes in (minor updates to test programs).

The ofiwg repo is intended as the official repo, as it would allow group maintainership.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
