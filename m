From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Tue, 21 Dec 2010 22:33:15 +0200
Message-ID: <7E95F01E94AB484F83061FCFA35B39F8794E40@exil.voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com><1292257370-24391-6-git-send-email-nirm@voltaire.com><20101214183458.GD2506@obsidianresearch.com><1292769382.2369.2145.camel@nirm-desktop><20101220215433.GB12090@obsidianresearch.com><1292943950.2369.3198.camel@nirm-desktop> <20101221181043.GD12090@obsidianresearch.com> <7E95F01E94AB484F83061FCFA35B39F8794E3F@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> These are some of the differences
> from the socket interface, which immediately creates a kernel resource
> for each FD that is opened.

Not immediately of course, but you understand my point hopefully...

Nir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
