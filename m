From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: HFI1 code duplication todo
Date: Fri, 20 Nov 2015 16:12:31 +0300
Message-ID: <20151120131231.GW18797@mwanda>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151119222319.GA17605@phlsvsds.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, dledford@redhat.com, gregkh@linuxfoundation.org
List-Id: linux-rdma@vger.kernel.org

At the beginning when hfi1 was put into staging, then it was easy enough
for Greg to take those patches but now it feels awkward.  Probably
Doug and the linux-rdma@vger.kernel.org people should start maintaining
the drivers/staging/rdma directory.  Like merge Greg's tree and pull in
whatever checkpatch fixes are still on the list and then take over from
there...

regards,
dan carpenter
