From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] IB/nes: Remove unnecessary parentheses
Date: Thu, 20 Sep 2018 09:47:45 -0700
Message-ID: <CAKwvOdnB32mZ900adeMmBpXTa6LjzAOooaGS+w96vkjZR=G_HQ@mail.gmail.com>
References: <20180920032956.14360-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920032956.14360-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: faisal.latif@intel.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 19, 2018 at 8:30 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when more than one set of parentheses are used in single
> conditional statements.
>
> drivers/infiniband/hw/nes/nes_hw.c:1446:27: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>         } while ((temp_phy_data2 == temp_phy_data));
>                   ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
> drivers/infiniband/hw/nes/nes_hw.c:1446:27: note: remove extraneous
> parentheses around the comparison to silence this warning
>         } while ((temp_phy_data2 == temp_phy_data));
>                  ~               ^               ~
> drivers/infiniband/hw/nes/nes_hw.c:1446:27: note: use '=' to turn this
> equality comparison into an assignment
>         } while ((temp_phy_data2 == temp_phy_data));
>                                  ^~
>                                  =
>
> Remove the unnecessary parentheses to silence this warning.
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/infiniband/hw/nes/nes_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
> index bd0675d8f298..5517e392bc01 100644
> --- a/drivers/infiniband/hw/nes/nes_hw.c
> +++ b/drivers/infiniband/hw/nes/nes_hw.c
> @@ -1443,7 +1443,7 @@ static int nes_init_2025_phy(struct nes_device *nesdev, u8 phy_type, u8 phy_inde
>                 mdelay(1);
>                 nes_read_10G_phy_reg(nesdev, phy_index, 0x3, 0xd7ee);
>                 temp_phy_data2 = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
> -       } while ((temp_phy_data2 == temp_phy_data));
> +       } while (temp_phy_data2 == temp_phy_data);
>
>         /* wait for tracking */
>         counter = 0;
> --
> 2.19.0
>

Nathan, thanks for this patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>


-- 
Thanks,
~Nick Desaulniers
