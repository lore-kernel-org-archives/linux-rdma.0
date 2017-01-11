From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/9] Move dma_ops from archdata into struct device
Date: Wed, 11 Jan 2017 07:46:24 +0100
Message-ID: <20170111064624.GA26893@kroah.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
	<20170111005648.14988-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170111005648.14988-3-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aurelien Jacquiot <a-jacquiot-l0cyMroinI0@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Muli Ben-Yehuda <mulix-BzGcCpaT2IbYtjvyW6yDsg@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Filippov <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Hans-Christian Egtvedt <egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org>, Jonas Bonn <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>, linux-am33-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-c6x-dev-jPsnJVOj+W6hPH1hqNUYSQ@public.gmane.org, Yoshinori Sato <ysato-Rn4VEauK+AKRv+LV9MX5uooqe+aC9MnS@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hexagon-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "James E . J . Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>, Doug Ledford <dledford@r>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 10, 2017 at 04:56:41PM -0800, Bart Van Assche wrote:
> Several RDMA drivers, e.g. drivers/infiniband/hw/qib, use the CPU to
> transfer data between memory and PCIe adapter. Because of performance
> reasons it is important that the CPU cache is not flushed when such
> drivers transfer data. Make this possible by allowing these drivers to
> override the dma_map_ops pointer. Additionally, introduce the function
> set_dma_ops() that will be used by a later patch in this series.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: Aurelien Jacquiot <a-jacquiot-l0cyMroinI0@public.gmane.org>
> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Cc: Chris Zankel <chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org>
> Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> Cc: Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Haavard Skinnemoen <hskinnemoen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Hans-Christian Egtvedt <egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org>
> Cc: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: James E.J. Bottomley <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
> Cc: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
> Cc: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
> Cc: Jon Mason <jdmason-zqedIHPRSYI@public.gmane.org>
> Cc: Jonas Bonn <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>
> Cc: Ley Foon Tan <lftan-EIB2kfCEclfQT0dZR+AlfA@public.gmane.org>
> Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Max Filippov <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Mikael Starvik <starvik-VrBV9hrLPhE@public.gmane.org>
> Cc: Muli Ben-Yehuda <mulix-BzGcCpaT2IbYtjvyW6yDsg@public.gmane.org>
> Cc: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
> Cc: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
> Cc: Stafford Horne <shorne-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Stefan Kristiansson <stefan.kristiansson-MbMCFXIvDHJFcC0YU169RA@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Yoshinori Sato <ysato-Rn4VEauK+AKRv+LV9MX5uooqe+aC9MnS@public.gmane.org>
> Cc: adi-buildroot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> Cc: linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-am33-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> Cc: linux-c6x-dev-jPsnJVOj+W6hPH1hqNUYSQ@public.gmane.org
> Cc: linux-cris-kernel-VrBV9hrLPhE@public.gmane.org
> Cc: linux-hexagon-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-m68k-cunTk1MwBs8S/qaLPR03pWD2FQJk+8+b@public.gmane.org
> Cc: linux-metag-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
> Cc: linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-snps-arc-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> Cc: linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org
> Cc: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
> Cc: nios2-dev-g9ZBwUv/Ih/yUk5EbOjzuce+I+R0W71w@public.gmane.org
> Cc: openrisc-cunTk1MwBs9a3B2Vnqf2dGD2FQJk+8+b@public.gmane.org
> Cc: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: uclinux-h8-devel-5NWGOfrQmneRv+LV9MX5uooqe+aC9MnS@public.gmane.org

That's a crazy cc: list, you should break this up into smaller pieces,
otherwise it's going to bounce...

> diff --git a/include/linux/device.h b/include/linux/device.h
> index 491b4c0ca633..c7cb225d36b0 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -885,6 +885,8 @@ struct dev_links_info {
>   * a higher-level representation of the device.
>   */
>  struct device {
> +	const struct dma_map_ops *dma_ops; /* See also get_dma_ops() */
> +
>  	struct device		*parent;
>  
>  	struct device_private	*p;

Why not put this new pointer down with the other dma fields in this
structure?  Any specific reason it needs to be first?

thanks,

greg k-h
