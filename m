From: Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Versions of packages included in rdma-core
Date: Thu, 1 Dec 2016 11:03:08 +0100
Message-ID: <20161201100308.7zg4x557as7ruwge@paradies.suse.de>
References: <20161201080430.jrcketnrljckdbix@paradies.suse.de>
 <20161201081826.GD4497@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161201081826.GD4497-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Stefan Fent <sf-l3A5Bk7waGM@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

* Leon Romanovsky (leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) [20161201 09:18]:

> We imported everything published in their respective git repositories.
But as it looks there isn't a log entry that marks the import. This makes it
hard to compare what we have in SLES to rdma-core to determine whether we do
the switch for the next service pack or wait for the next major SLES
version.

> Did you try to use git log --follow relevant_file?

I didn't know that. But that would mean I would have to compare the git logs
of all imported packages to see where they star t to differ :( I had hoped
for an easier way, oh well...

Philipp
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
