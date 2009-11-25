From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: [PATCH] uDAPL v2: scm: client side setsockopt NODELAY
	fails if	data arrives before setting
Date: Tue, 24 Nov 2009 16:37:19 -0800
Message-ID: <7EDB3F0A31604B79A030FCF46834E443@amr.corp.intel.com>
References: <E3280858FA94444CA49D2BA02341C98361B96A62@orsmsx506.amr.corp.intel.com>
	<20091125002914.GQ6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091125002914.GQ6188@obsidianresearch.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>, "Davis, Arlin R" <arlin.r.davis@intel.com>
Cc: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org

>TCP_NODELAY is not a POSIX feature, and the common UNIX/Linux behavior
>is to allow it to be set/unset at any time. Strange the Windows would
>be restrictive in this way.

We were easily able to reproduce errors on Windows trying to set this option
after the connection was established, but it didn't occur every time.  The
documentation didn't list any specific restrictions, but our guess is that
Windows requires that it be set before any data is sent or received on the
socket.  In any case, the errors went away after moving the call before connect.

- Sean
