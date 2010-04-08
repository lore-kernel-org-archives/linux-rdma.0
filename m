From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Thu, 08 Apr 2010 16:29:06 -0700
Message-ID: <adapr29ttfh.fsf@roland-alpha.cisco.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	<20091203190624.29507.22110.stgit@chromite.mv.qlogic.com>
	<adaiq81wtw3.fsf@roland-alpha.cisco.com>
	<1270762193.2278.25.camel@chromite.mv.qlogic.com>
	<adask75vdbs.fsf@roland-alpha.cisco.com>
	<20100408151234.43f4bfc6.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100408151234.43f4bfc6.weiny2-i2BcT+NCU+M@public.gmane.org> (Ira Weiny's message of
	"Thu, 8 Apr 2010 15:12:34 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I for one would rather not see this die.  We have debugged some critical
 > issues using this data.  The sysfs entries above are what Mellanox uses.
 > Should those also be changed?

Which sysfs entries?  I don't see any likely looking code in either of
the Mellanox drivers.

 - R.

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
