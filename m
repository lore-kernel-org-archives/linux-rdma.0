From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] opensm - use C99 transportable data type for
 pointer storage
Date: Thu, 12 Nov 2009 21:05:40 +0200
Message-ID: <20091112190540.GN7192@me>
References: <086F8B40ADA84EE7B6398F4761937836@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <086F8B40ADA84EE7B6398F4761937836@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Stan C. Smith" <stan.smith@intel.com>
Cc: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org

On 17:48 Mon 09 Nov     , Stan C. Smith wrote:
> 
> In order to skip the #ifndef __WIN__ around #include <stdint.h>, inttypes.h was used.
> 'inttypes.h' includes stdint.h and exists in the WinOF svn tree.
> OFED opensm builds without problems on EL 5.3.
> 
> Signed-off-by: stan smith <stan.smith@intel.com>

Applied. Thanks.

Sasha
