From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: Re: [PATCH 1/2] mm: add locked parameter to get_user_pages()
Date: Mon, 7 Nov 2016 11:00:50 +0000
Message-ID: <20161107110050.GA25313@lucifer>
References: <20161031100228.17917-1-lstoakes@gmail.com>
 <20161031100228.17917-2-lstoakes@gmail.com>
 <20161107104918.GQ30704@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20161107104918.GQ30704@axis.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: devel@driverdev.osuosl.org, Rik van Riel <riel@redhat.com>, linux-ia64@vger.kernel.org, linux-cris-kernel@axis.com, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Paolo Bonzini <pbonzini@redhat.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 07, 2016 at 11:49:18AM +0100, Jesper Nilsson wrote:
> For the cris-part:
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

Thanks very much for that, however just to avoid any confusion, I realised this
series was not not the right way forward after discussion with Paolo and rather
it makes more sense to keep the API as it is and to update callers where it
makes sense to.
