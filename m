From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] staging: lustre: ko2iblbd: handle ib_dereg_mr removal
Date: Mon, 3 Oct 2016 00:31:04 -0700
Message-ID: <20161003073104.GA28412@infradead.org>
References: <1475461351-21495-1-git-send-email-jsimmons@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1475461351-21495-1-git-send-email-jsimmons@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Simmons <jsimmons@infradead.org>
Cc: devel@driverdev.osuosl.org, Andreas Dilger <andreas.dilger@intel.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Oleg Drokin <oleg.drokin@intel.com>, Lustre Development List <lustre-devel@lists.lustre.org>
List-Id: linux-rdma@vger.kernel.org

Hell no.  If you had actually read the changelog you'd see that there
is a reason the functions went away, and simply calling the underlying
methods (which also will go away) will not fix it.

Please go back reading the changelogs, and while we're at it read some
basic introductions into the RDMA programming model.  As a little
shortcut: relying on any form of a global registration for the rkey
is inherently unsafe and only allowed as an option variant for
very trusted environments (thing single box appliances).  You'll need
to do a real memory registration here and not drag that old crap along.
