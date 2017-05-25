(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �0'Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[���1HB�u��	7�'��ʍ��4��|
�4M�(M"�w���(�RM���1�R#?�9����vZ�}Y��v��\��(�G�O|?�������4^f2".�?E�d%�2��oS�_�C��_�,��w���叒$]ɿ\(����⊽u4\.��9�%���}��S���p��)�*���k��O'^���r�I�8
�"�;y?��{4%�B��Oj�#��?����ʽ������]��]�<�l�%l��i��X�$l�sY��|�t|ԧ)��\��(�EQ�'����^������?E���q}����ėRF�����Nl�jM�>��t��Xk��)R�.4Q�e$�e���$X`�{+X�R\�ʦ�m�0R�?����_5�
�B ��@���c%�&�'pG���&�OQ4�!
�\gu���=���p:�JH�w��L�	k[�ˋY�E�[�~dK��B]��:5VT��������4�m/�.]?]��1|������_)�(��e\�^'~����������p +�_�^�Y��Bm�j~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��F �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���z�ŌG�!i�^=ܧ� v0?�`����Сs͡��Չ�XD���Cq'������Y�M��I[,��oā�q�t1�S�b>��Cso୥bpc�S��L� O
��
p�����yxsh���H"S�n$L�^�[\c�ƨ��s��/;hS@�N��䒡ʅ�ʻ�R�L�ŭ�L�f�E�F�S q|~O�E�5�(�dz�>h���@���kp+O<��p `��Q�:��xY���"cR��M����� ��z`m:�������}�\)L�B�<@B��^�x�:tr �	>��-�F\Ę�2�`���>;��ߵs9䖓�%���D�b�ՇL�@�"=�cш�̢O�Q��>,>0����{f��_���4|����Q���R�A����x��ѧ���R�x���Y��Nt��:PC��f{��W�d�%��'�s>��v<�3�H'B�~Ĩ�*�#F};��rd��A��`� �EZ��`����4E�w���7��0EWrH<�0��'�5�%��;�b��V.�S^S�Q���lM�HM\L���C�f�ߛe�.�i���ռ���ž�@h]�.?���gN�ȅ�D�=�5af[8�ȑ�[���9k@@H\^d��!��
 y;?U2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~:h=��E�Fѥ>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db<�?�/��~����I���?J����g�������������������s�_��o�	���	�@*�/�$�ό���RP��T�?�>�I���D1�(�-�N�S$[�w���@X$�q��\֡0�\�P��Y������e����G�?IU�_� ��o���~�Ѥ���#��u�u<K�s�G ��e�?�����-ض�`FL�9i��e�l)�z�"��Ɨs�3ܠ��Ȃ�`�͍9�Z�+���u�`5J�`�Y��4��ދ_����S�������������/��_��W��U������S�)� �?J������+o�����o�Px$t�0�7[� -x�������]>tl�0�ެ���31��B���d�{*��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x��	����NV�;�g���5�H��q9#�����@~���-�A�%�S�q�s ��l(bK Ӑ���s'������m�2	\X�7h�y��磅iϞ�P���I`*����;����C���b��v�in��:K{��,�;�!/7;��
�(!�D��|$s�"yY��	���@N�b�Ak����S���������2�!�������KA��W����������k�����E���K�%���_��������T�_���.����͞O����R����K��cl���u(�p�v};@�Y�sG�%Pa�a� !}�Y���*���C�<��)������*vE~�Z������֘.�m��H�n�����'/H���?�@�N�ǝ:���А�Q����2�F�	�6v�3�J������nO@�C���V>����3�pN)9��ͪ��w����S�O?�����&���r��O|�)��X��������}}�R�\�8�T��W�o_��.�?�x%�2��i;����Q������a�����?�j��|��gi�.�#s�&]ƦX
u1
�\�e1���F�u� p�`���m�a}�Z(*e����9��T��|>.X��"�?��%�a��bB��vK#�Ļ���Jw�4Q?_����Є/�u�]q��ϥ��
t��yԘ	��G�׌�8��C0�2�v;Dت�L�5Aut_$�=��z���n|��i;�;�?����R�;�(I<��(��2�I��A���B�D���C	�i�7Q�T�_x-��}������?w�J���U�k,a	�0�������G��,	��3���s�=�J���.�j�u#}�F��;���@7�G�@CwA��h�A���vn�8P8��G`�t����t�v�#�|����mc�y[�ȵ�f��#<���39��&���k�͛#���L�-��%��f�f�����'�n��(F�|d���A7��:���6��9Z��5��nM]9�5��	+�����Bm���_�SI�;�!qk!̻��!@]�Hr��pY�n���a���&8L9��Ӽ��+.��Sh+��mg#���s�O	+g�O�� r��A 5Ý�i'�I�D��?�}z��Vu}�Ț�Ґ^<�G��������ǉ��/���O���7�s��r+7�D������@����R������6���z��ps'���B�ó�ч���7���3C��o�<���� o�2|�z����k����&>q[��'�A@�H���PwSR������ؚ���ms�ѷl���D��!�5S9v-Mhҩl�$��ԺN�t-�\9N�j�x�<��o?�l�C�����}�@�,4GN�F��Y�ͻ�����2�g�d5���ן��v�^�=�K�^����w:��M!��#Z�������g�?�G��������Gh���+���O>�������Ϙ����?e��=���������G��_��W��������N�����0����rp��/��.��B�*��T�_���.���?�|�����Rp9�a�4��$J1E����>�Q$�8�N�8��(��S��庘�0^��[���b����
��J����2%[N��95c����ͩ����-y#��E������Ds:n+� �Jx����^�����ط�ܱ
#Jj�9��uG� ?��]K'��@9���C�ި��Q��м���^x�;��b�GI����h������Gq�|z��b������f���Z���2?�N]?�
�j��/��4�C�km�O�t�{a1�I��k�1�E\���5re/��}����N�x�����Z��&N���4�����.��Z�������8]g���������Ҋ��K�k-�Ԯ��_O�Ż�])��Պ`��k����yh�:����e�|��y�+�v�`���;���]y�.�ƋM�?�k��Sݾ��)n�{���K?�Y�Q1*\��2�(pk+܎����r_V��.[]]uQ�i�����MG��
A��o���ߋ��׾�WD���e�ZQI��`�;j���y�av}�(�΢г/7�˃����·��śWK���Q��l/V`t�7E�p�xV{����ǒ�LZ�����q��q����N��+��o?�M�v�����U������g�����@.*�=,��SS�8�O��7M���8Y�a���	��.Nד�s]��L�GR��j�h�B"GE��H	����}7@�ȿ?���Y����?V��Wtñ�E��������w�F���Y��{�@�Uő�m�n��ɦR��וU��f9�}�axgkxk�p�Y�gK����]m��V�n/���s�����@oCPoѝ�u��)P�8q�q���N���q�$N��]!�R���P�� -hT�� �����Z	-�
�e�h%�p�$�d��d���R�+�q��|�}����s�1��J��B���}ؼ�[0�t6g�Llr�pKn%$l"��U*��������芤�t.���Jgc�(	�m]=f�:y�P������fSd��c��E�E�V�i�G�h1�	A�$^���䜐�!&L3y��+����(� ����]��.A�F �5�� �ڱ�0�\��R\�k�7,�l�����P�Ǧ*i���G��a��~G��O�����/��-���[5�����+ĻE�3��}0���+7�EY=4��H�-����W�u�h[��F����[(��KS�*�&jb�f܂��8ۋ��)�M�76���-���y8���k9p�����4�����z_��.L�4`u���V����:��ݿ�)�H��^����%<��q�G�kJ�Ӛ�-�j:�[�T�ͤMX����'�N�>s�ܰ�Q0{:��拰�~|A���D���{f���2�xT�&����"L��a��h+�����t](8͹�-߆0U䕜���)��-�� }L�7��Mk��U��uT��|�j ��,	5:}�%.-��^���:r�h_/���YmI�7v�|�s�H�#מZ�4r�$�Lُۣ%)h��)3�%��t���^fLЊ�-�Y�x�F��AO4��lr��oK��	�>T�5����*���;[����:����-p�X�E5 ���>��Y�iѽ�@px��'o��ƆǺ�W����xqs����?��������?�/��iPں�si�����r�c�č'���7��y�!�t��}?�������"����@��a>!�	>`B����E�{G�����CW~���O=X��ۅ�\��S�r���� �<π�Bw>� �u����p��n�7pG^xx�������!_��|�����\<���M���M��殴D`��sܼ����	9��e!���L�|k�2'�Zפ�kM�4�O�0�z緅��"ׇɞ ��í�ލ���7��z��h��Ʃa��z�`)���gǜP�r��T�A�E�°X���e�by\ĉ\����9��-����G�l�lC�p%JSE����aT`�������q�e�lx�#\b�U�0O΄Wɂcv{k��H.��\k7S�<tJ�T}�f�8`�d�R��W3����Ҿ�G�i�R�^E�U��1��3zFC�~�a��V�#�!_��0a&�Ä݄	�|�D�ݏ����ѹM=!�ڛz�S�k~~K�)����FȺW�(%��x���c^2��$ӡ\Z��R����L���Hb����sa�P�q��k�=��\�η��bJ��Q�CV���,��fP���A*ҍ�x��S��^��+XBV��E�>�����ë���j2F3�X�'��lDI��8-+�z�����z��
7��T�D�%%��Ho3\��m4_}e�����ـuAY����BDKt��:���(�M�4��V�(��N<Z���>�u��H1J�3�̈́KIF��N ��ڨ���锅��h�&�FK�:`X�pE2�Q2K�rDxAv���u	��x60�)�/&�N�WC� PO/W�h���$f)�h\/�q����Τc� Vhs��TO{��<�EJ���$V)�p���W�����c0r�&q��y �y�ᩱ7-��F��_"�hPˊb�,�"�GI-^V�
�ԸV��ɖp�{�XBi�)����S���n(�Q���z����?�e<�\U�%e9"� �VY��.�q���!+Ut	e�<;(-����?�����ݖ����h�B�R�_��˱|Z�1l�����^�;NY܎���l�϶�϶s�4~�w��FW��]ȵ�;�d��^غc�
���Wi;�Lϐ�ʾ}.�6re>����EeE�v��v��滂l���^�����{چ-��B��9(�*a�<���#AԺ��L.�<�&1��ht���U�@�抺��WĎ�3�#MD��Kࢡ*�-��X��5�"����~�ocW�y�e7�mw�U��֛0��}������"�4jV͑�"�B�{��1���m���¼��)����up��4������1+V��)��A�� �����@��U �]V$}������D��?���y��6�ۇ�9/�K��/ϝ8tOL���Қ�Z�(��P������KJ�𠭎����h.:�Ok��xX���6]p�rd����κ��V��4�5gс<8�,DJLE�>���ޘ�UZ�2��}|L#b���\(+��VpLu�X<���0��h�/��R��Q��*E���t�MB%�,��5��Y��؃�a�If�d1A��2���99}3�Y����p�D4�j(��A��{��\||@�=�NjL�\�@s�D�#�@V,�	Ez@-������*�G}X��|�i����x82�x/$�AB
wd}�f0���P�vK��B���j4��8.5�� ��c����c�q���z��G��A��s��e��:&�)f>ӆ)0۳{y
>8��^䲝���yX�=,�����x�x�{[<,'��Ɖ�m:���#|����j�ԅ4o~~D,)����9,Py����6��A�YL�5(2��E�5gY���0�ryg�����"�v��#tX�c���݌!�O�ZG���zBɪ֧�V�`�����qt4�h��Q0&!E��`��X8m0�0B���E��}��b���q߁��p����'U�w1\Ԇ����E���rU�zcR�)�~%S#Ӣ.U�1��R3�ǃ(��������!��-x ��ӢQmV
�~��&=�f���]�yc�1�8�ތ�Tޏw1ⷑS�=�S��b���F!��l;7��V�.�w�8oȍ����=��ӭh��_�qߜ��4�I�j�h�{�>p�����������&�mA���\����ܨWY���U���"r��vso���ˏ�����z?����/~��{��^��s~r��ou���k�ws��c�D�s.�D�'�?��G���?o��;��~������w����#�_~2����y�^��'�_��s�"��I�$�b��[w�x��C�+z�+��D���\�]�Cw�������[������/�������#�a�K�+����gn��Ej�/j�C�t��M��	8�N�+���+��v��ӡv:�N�gs|�����|����q
R�&4� �J���E.h�o��U��Y�s ��[������>F�����ב��	/ ��q����)������p��5���#y��� 3���Ks�l�yZΜ'��̙q�8��93�q8�q�̜a����܎�97�;w��ڦ��W�<z�d�������s�p�p����WkQ3u  