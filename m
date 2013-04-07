From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/5] tipc: add InfiniBand media type
Date: Sun, 7 Apr 2013 11:43:45 +0200
Message-ID: <20130407094345.GA24908@macbook.localnet>
References: <1364993010-15515-1-git-send-email-kaber@trash.net>
 <1364993010-15515-5-git-send-email-kaber@trash.net>
 <51613A0A.3060706@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51613A0A.3060706@acm.org>
Sender: netdev-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: jon.maloy@ericsson.com, allan.stephens@windriver.com, netdev@vger.kernel.org, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 07, 2013 at 11:19:06AM +0200, Bart Van Assche wrote:
> On 04/03/13 14:43, Patrick McHardy wrote:
> >diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
> >+#ifdef CONFIG_TIPC_MEDIA_IB
> >+int  tipc_ib_media_start(void);
> >+void tipc_ib_media_stop(void);
> >+#else
> >+int  tipc_ib_media_start(void) { return 0; }
> >+void tipc_ib_media_stop(void)  { return; }
> >+#endif
> 
> Is the above a definition of a non-inline function pair in a header
> file ? I'm afraid that will cause trouble when including that header
> file in more than one source file.

Oops right, I'll fix that up.
