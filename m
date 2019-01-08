From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 0/8] net: y2038-safe socket timestamps
Date: Tue, 08 Jan 2019 13:49:04 -0800 (PST)
Message-ID: <20190108.134904.797789678341389884.davem@davemloft.net>
References: <20190108032657.8331-1-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108032657.8331-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: deepa.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org, chris@zankel.net, deller@gmx.de, dhowells@redhat.com, fenghua.yu@intel.com, isdn@linux-pingi.de, jejb@parisc-linux.org, linux-afs@lists.infradead.org, linux-alpha@vger.kernel.org, linux-arch@vger.kernel.org, linux-ia64@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, linux-xtensa@linux-xtensa.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, sparclinux@vger.kernel.org, tglx@linutronix.de, ubraun@linux.ibm.com
List-Id: linux-rdma@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Mon,  7 Jan 2019 19:26:49 -0800

> The series introduces new socket timestamps that are
> y2038 safe.

Great discussion, but this is definitely net-next material and the net-next
tree is not open at this time.
