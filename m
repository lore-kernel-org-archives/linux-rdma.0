From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 06/18] staging/rdma/hfi: Add one-time LCB reset
Date: Thu, 19 Nov 2015 17:10:38 -0800
Message-ID: <20151120011038.GF11695@kroah.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
 <1447472236-622-6-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1447472236-622-6-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Jubin John <jubin.john@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 13, 2015 at 07:37:04PM -0800, Jubin John wrote:
> From: Dean Luick <dean.luick@intel.com>
> 
> Add one-time LCB reset on driver load to pre-emptively work
> around any LCB power cycle issues.

You dropped a character in your Subject line :(
